import 'package:drive_safe/src/features/example/data/mock_friends.dart'; // Corrected import
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddFriendsScreen extends StatefulWidget {
  final Function(Map<String, String>) onFriendAdded;

  const AddFriendsScreen({super.key, required this.onFriendAdded});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final TextEditingController _friendCodeController = TextEditingController();
  Map<String, String>? _searchedFriend;

  void _findFriend() {
    String enteredCode = _friendCodeController.text.trim();

    setState(() {
      _searchedFriend = mockFriends.firstWhere(
        (friend) => friend['phone'] == enteredCode,
        orElse: () => {},
      );
    });
  }

  void _addFriend() {
    if (_searchedFriend != null) {
      widget.onFriendAdded(_searchedFriend!);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.black,
          title: const Text("Success!", style: TextStyle(color: Colors.white)),
          content: const Text("Friend Added Successfully.",
              style: TextStyle(color: Colors.white)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close popup only
              },
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );

      setState(() {
        _searchedFriend = null; // Clear after adding
        _friendCodeController.clear(); // Reset input field
      });
    }
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
                keyboardType: TextInputType.phone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Phone Number",
                  hintStyle: TextStyles.searchHint,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                  text: "Find Friend",
                  onPressed: _findFriend,
                  backgroundColor: AppColors.customPink),
            ),
            if (_searchedFriend != null && _searchedFriend!.isNotEmpty) ...[
              const SizedBox(height: 20),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: _searchedFriend!['avatarColor'] == 'blue'
                      ? Colors.blue
                      : Colors.purple,
                  child: Text(
                    _searchedFriend!['initial']!,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                title: Text(_searchedFriend!['name']!,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                subtitle: Text(_searchedFriend!['description']!,
                    style: const TextStyle(color: Colors.white70)),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.customPink,
                  ),
                  onPressed: _addFriend,
                  child:
                      const Text("Add", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
