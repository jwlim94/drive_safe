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
        // 🔥 Keep existing icons and UI
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

        // 🔥 Fetch and display friends based on the friends array in Firestore
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
                            _showConfirmDeleteDialog(
                                context, ref, currentUser.id, friend['id']);
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

  /// 🔥 Show confirmation dialog before deleting a friend
  void _showConfirmDeleteDialog(BuildContext context, WidgetRef ref,
      String currentUserId, String friendId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title:
            const Text("Are you sure?", style: TextStyle(color: Colors.white)),
        content: const Text("Do you really want to delete this friend?",
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // ❌ Cancel button
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              _removeFriend(context, ref, currentUserId,
                  friendId); // ✅ Proceed with deletion
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 🔥 Delete friend and show "Successfully Deleted!" popup
  void _removeFriend(BuildContext context, WidgetRef ref, String currentUserId,
      String friendId) {
    ref
        .read(updateUserFriendsControllerProvider.notifier)
        .updateUserFriends(friendId, 'remove')
        .then((_) {
      _showSuccessDialog(context, "Successfully Deleted!");
    }).catchError((error) {
      _showErrorDialog(context, "Failed to delete friend: $error");
    });
  }

  /// ✅ Success message popup
  void _showSuccessDialog(BuildContext context, String message) {
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

  /// ❌ Error message popup
  void _showErrorDialog(BuildContext context, String message) {
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
}
