import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_friends_controller.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddFriendsScreen extends ConsumerStatefulWidget {
  const AddFriendsScreen({super.key});

  @override
  ConsumerState<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends ConsumerState<AddFriendsScreen> {
  final TextEditingController _friendCodeController = TextEditingController();
  Map<String, dynamic>? _searchedFriend;
  bool _isLoading = false;
  bool _isAddingFriend = false; // ✅ Prevents multiple submissions

  /// Search for a friend in Firestore
  void _findFriend() async {
    String enteredCode =
        _friendCodeController.text.trim().toUpperCase(); // 🔥 Ensure uppercase

    if (enteredCode.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchedFriend = null;
    });

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('code', isEqualTo: enteredCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _searchedFriend = querySnapshot.docs.first.data();
        });
      } else {
        _showErrorDialog("No friend found with this code.");
      }
    } catch (e) {
      _showErrorDialog("Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Add friend with proper state handling
  void _addFriend() async {
    if (_searchedFriend == null || _isAddingFriend) return;
    setState(() {
      _isAddingFriend = true;
    });

    final friendId = _searchedFriend!['id'];

    try {
      await ref
          .read(updateUserFriendsControllerProvider.notifier)
          .updateUserFriends(friendId, 'add');

      if (!mounted) return;
      _showSuccessDialog("Friend Added Successfully.");
      _resetSearch();
    } catch (error) {
      if (!mounted) return;
      _showErrorDialog("Failed to add friend: $error");
    } finally {
      if (mounted) {
        setState(() {
          _isAddingFriend = false;
        });
      }
    }
  }

  /// Show success dialog
  void _showSuccessDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Success!", style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  /// Show error dialog
  void _showErrorDialog(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Error!", style: TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// Reset search state
  void _resetSearch() {
    setState(() {
      _searchedFriend = null;
      _friendCodeController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.customBlack,
      appBar: AppBar(
        backgroundColor: AppColors.customBlack,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Enter your friend's code", style: TextStyles.h3),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.customWhite, width: 1),
              ),
              child: TextField(
                controller: _friendCodeController,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  _friendCodeController.value =
                      _friendCodeController.value.copyWith(
                    text: value.toUpperCase(),
                    selection: TextSelection.collapsed(offset: value.length),
                  );
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Friend Code",
                  hintStyle: TextStyles.searchHint,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: _isLoading ? "Searching..." : "Find Friend",
                onPressed: _isLoading ? null : _findFriend,
                backgroundColor: AppColors.customPink,
              ),
            ),
            if (_searchedFriend != null) ...[
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Text(
                    _searchedFriend!['name'][0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                title: Text(_searchedFriend!['name'],
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(_searchedFriend!['email'],
                    style: const TextStyle(color: Colors.white70)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.customPink,
                  ),
                  onPressed: _isAddingFriend ? null : _addFriend,
                  child: _isAddingFriend
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Add",
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
