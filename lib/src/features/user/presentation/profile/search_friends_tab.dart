import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchFriendsTab extends ConsumerStatefulWidget {
  const SearchFriendsTab({super.key});

  @override
  ConsumerState<SearchFriendsTab> createState() => _SearchFriendsTabState();
}

class _SearchFriendsTabState extends ConsumerState<SearchFriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFriends = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
  }

  /// 🔥 검색 기능 (입력된 값이 포함된 친구만 필터링)
  void _searchFriends(List<Map<String, dynamic>> allFriends) {
    setState(() {
      filteredFriends = allFriends
          .where((friend) => (friend['name']?.toString() ?? "")
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      showDropdown = false;
    });
  }

  /// 🔥 입력할 때 자동 필터링
  void _updateDropdown(String value, List<Map<String, dynamic>> allFriends) {
    setState(() {
      showDropdown = value.isNotEmpty;
      filteredFriends = allFriends
          .where((friend) => (friend['name']?.toString() ?? "")
              .toLowerCase()
              .startsWith(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser == null) {
      return const Scaffold(
        backgroundColor: AppColors.customBlack,
        body: Center(
          child: Text("No user logged in",
              style: TextStyle(color: Colors.white54, fontSize: 16)),
        ),
      );
    }

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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.id)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
            return const Center(
              child: Text(
                "No friends found",
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            );
          }

          // Firestore에서 가져온 friends 배열
          List<dynamic> friendIds = userSnapshot.data!['friends'] ?? [];

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .where(FieldPath.documentId, whereIn: friendIds)
                .get(),
            builder: (context, friendsSnapshot) {
              if (friendsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(color: Colors.white));
              }

              if (!friendsSnapshot.hasData ||
                  friendsSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "No friends found",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                );
              }

              // Firestore에서 가져온 친구 리스트
              final friendsList = friendsSnapshot.data!.docs.map((doc) {
                return doc.data() as Map<String, dynamic>;
              }).toList();

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔥 기존 UI 유지 - 검색 필드
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: AppColors.customWhite, width: 1),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              onChanged: (value) =>
                                  _updateDropdown(value, friendsList),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search",
                                hintStyle: TextStyles.searchHint,
                                contentPadding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                              icon:
                                  const Icon(Icons.search, color: Colors.white),
                              onPressed: () => _searchFriends(friendsList),
                              splashRadius: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 🔥 기존 UI 유지 - 검색 결과 리스트
                    if (showDropdown && _searchController.text.isNotEmpty)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.customBlack,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: AppColors.customWhite, width: 1),
                        ),
                        child: Column(
                          children: filteredFriends.map((friend) {
                            return ListTile(
                              title: Text(
                                  friend['name']?.toString() ?? "Unknown",
                                  style: const TextStyle(color: Colors.white)),
                              onTap: () {
                                _searchController.text =
                                    friend['name']?.toString() ?? "";
                                _searchFriends(friendsList);
                              },
                            );
                          }).toList(),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // 🔥 기존 UI 유지 - 검색된 친구 리스트 (Race 버튼 포함)
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredFriends.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: filteredFriends[index]
                                          ['avatarColor'] ==
                                      'blue'
                                  ? Colors.blue
                                  : Colors.purple,
                              child: Text(
                                filteredFriends[index]['initial']?.toString() ??
                                    "",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            title: Text(
                              filteredFriends[index]['name']?.toString() ??
                                  "Unknown",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              filteredFriends[index]['description']
                                      ?.toString() ??
                                  "",
                              style: const TextStyle(color: Colors.white70),
                            ),
                            trailing: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customPink,
                              ),
                              onPressed: () {
                                print("Race button pressed");
                              },
                              child: const Text("Race",
                                  style: TextStyle(color: Colors.white)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
