import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_friends_controller.dart';
import 'package:drive_safe/src/features/user/presentation/profile/add_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/search_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsTab extends ConsumerWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserStateProvider);

    if (currentUser == null) {
      return const Center(
        child: Text(
          "No user logged in",
          style: TextStyle(color: Colors.white54, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔥 기존 아이콘 + UI 유지
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add,
                      color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddFriendsScreen(),
                      ),
                    );
                  },
                ),
                const Text("Add Friends",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.search, color: Colors.white, size: 40),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchFriendsTab(),
                      ),
                    );
                  },
                ),
                const Text("Search",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const Divider(color: Colors.white, thickness: 1.5, height: 20),

        // 🔥 Firestore에서 friends 배열 기반으로 친구 정보 가져오기 (UI 변경 없음)
        Expanded(
          child: StreamBuilder<DocumentSnapshot>(
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
                    "No friends added yet",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                );
              }

              final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>;
              List<dynamic> friendIds = userData['friends'] ?? [];

              if (friendIds.isEmpty) {
                return const Center(
                  child: Text(
                    "No friends added yet",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                );
              }

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(FieldPath.documentId, whereIn: friendIds)
                    .get(),
                builder: (context, friendsSnapshot) {
                  if (friendsSnapshot.connectionState ==
                      ConnectionState.waiting) {
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

                  final friendsList = friendsSnapshot.data!.docs.map((doc) {
                    return doc.data() as Map<String, dynamic>;
                  }).toList();

                  return ListView.builder(
                    itemCount: friendsList.length,
                    itemBuilder: (context, index) {
                      final friend = friendsList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(
                            friend['name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(friend['name'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(friend['email'],
                            style: const TextStyle(color: Colors.white70)),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.red),
                          onPressed: () {
                            ref
                                .read(updateUserFriendsControllerProvider
                                    .notifier)
                                .updateUserFriends(
                                    friend['id'], 'remove'); // ✅ 오류 수정
                          },
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
