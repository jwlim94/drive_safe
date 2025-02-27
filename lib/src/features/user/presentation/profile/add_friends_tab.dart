import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:drive_safe/src/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class AddFriendsScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onFriendAdded;

  const AddFriendsScreen({super.key, required this.onFriendAdded});

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final TextEditingController _friendCodeController = TextEditingController();
  Map<String, dynamic>? _searchedFriend;
  bool _isLoading = false;

  /// Firestore에서 친구 찾기
  void _findFriend() async {
    String enteredCode = _friendCodeController.text.trim();

    if (enteredCode.isEmpty) return;

    setState(() {
      _isLoading = true;
      _searchedFriend = null; // 이전 검색 결과 초기화
    });

    try {
      // Firestore에서 code 값이 입력한 코드와 일치하는 문서를 찾기
      var querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('code', isEqualTo: enteredCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _searchedFriend = querySnapshot.docs.first.data();
        });
      } else {
        setState(() {
          _searchedFriend = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("No friend found with this code."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 친구 추가
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
                Navigator.of(context).pop(); // 팝업 닫기
              },
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      );

      setState(() {
        _searchedFriend = null; // 검색된 친구 정보 초기화
        _friendCodeController.clear(); // 입력 필드 초기화
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
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  // 입력값을 모두 대문자로 변환하여 저장
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
