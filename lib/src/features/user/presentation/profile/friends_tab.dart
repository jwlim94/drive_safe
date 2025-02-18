import 'package:drive_safe/src/features/user/presentation/profile/add_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/search_friends_tab.dart';
import 'package:flutter/material.dart';

class FriendsTab extends StatelessWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                        builder: (context) => AddFriendsScreen(
                          onFriendAdded: (friend) {},
                        ),
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
                        builder: (context) => SearchFriendsTab(
                          addedFriends: [],
                        ),
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
        const Expanded(
          child: Center(
            child: Text(
              "No friends added yet",
              style: TextStyle(color: Colors.white54, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
