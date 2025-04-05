import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drive_safe/src/features/user/presentation/controllers/update_user_friends_controller.dart';
import 'package:drive_safe/src/features/user/presentation/profile/add_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/friend_profile_screen.dart';
import 'package:drive_safe/src/features/user/presentation/providers/current_user_state_provider.dart';
import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FriendsTab extends ConsumerStatefulWidget {
  const FriendsTab({super.key});

  @override
  FriendsTabState createState() => FriendsTabState();
}

class FriendsTabState extends ConsumerState<FriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> allFriends = [];
  List<Map<String, dynamic>> filteredFriends = [];
  bool showDropdown = false;
  bool isLoading = true;
  bool isSearchBarActive = false;

  @override
  void initState() {
    super.initState;
    setState(() {
      isSearchBarActive = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Filters friends based on search query
  void _searchFriends(String query) {
    setState(() {
      // Filter the allFriends list based on the search query
      filteredFriends = allFriends
          .where((friend) =>
              friend['name']
                  ?.toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) ??
              false)
          .toList();
      showDropdown = query.isNotEmpty && filteredFriends.isNotEmpty;
      isSearchBarActive = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserStateProvider);
    ref.watch(updateUserFriendsControllerProvider);

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
            Row(
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
                const SizedBox(
                  width: 50,
                ),
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh,
                          color: Colors.white, size: 40),
                      onPressed: () async {
                        await ref
                            .read(currentUserStateProvider.notifier)
                            .refreshAndSetUser();
                      },
                    ),
                    const Text("Refresh Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
        const Divider(color: Colors.white, thickness: 1.5, height: 20),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.customWhite, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged:
                      _searchFriends, // Call _searchFriends on text change
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyles.searchHint,
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _searchFriends(_searchController.text),
                  splashRadius: 24,
                ),
              ),
            ],
          ),
        ),
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

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where(FieldPath.documentId, whereIn: friendIds)
                    .snapshots(),
                builder: (context, friendsSnapshot) {
                  if (friendsSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
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

                  if (isSearchBarActive == false) {
                    // Corrected: Get the list of friends from the `docs` property
                    allFriends = friendsSnapshot.data!.docs.map((doc) {
                      return doc.data() as Map<String, dynamic>;
                    }).toList();
                    filteredFriends = allFriends;
                  } else {
                    // Initially, show all friends if the search query is empty and then show only the filtered ones
                    filteredFriends;
                  }

                  return ListView.builder(
                    itemCount: filteredFriends.length, // Use filteredFriends
                    itemBuilder: (context, index) {
                      final friend =
                          filteredFriends[index]; // Use filteredFriends
                      return ListTile(
                        onTap: () {
                          print('Tapped friend id: ${friend['id']}');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FriendProfileScreen(
                                  userId: friend['id'], carId: friend['carId']),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: Color(friend['primaryColor']),
                          child: Text(
                            friend['name'][0].toUpperCase(),
                            style: TextStyle(
                              color: Color(friend['secondaryColor']),
                            ),
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
              _removeFriend(
                  context, currentUserId, friendId); // ✅ Proceed with deletion
            },
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  /// 🔥 Delete friend and show "Successfully Deleted!" popup
  Future<void> _removeFriend(
      BuildContext context, String currentUserId, String friendId) async {
    try {
      await ref
          .read(updateUserFriendsControllerProvider.notifier)
          .updateUserFriends(friendId, 'remove');
      _showSuccessDialog("Friend Deleted Successfully.");
    } catch (error) {
      print(error);
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
            onPressed: () {
              Navigator.of(context).pop();
              // _resetSearch();
            },
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
