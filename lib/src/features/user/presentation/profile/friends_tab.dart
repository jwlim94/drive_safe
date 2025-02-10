import 'dart:convert';

import 'package:drive_safe/src/features/user/presentation/profile/add_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/search_friends_tab.dart'; // Import SearchFriendsTab
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<Map<String, String>> addedFriends = []; // Initially empty

  @override
  void initState() {
    super.initState();
    _loadFriends(); // Load saved friends on startup
  }

  Future<void> _loadFriends() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedFriends = prefs.getString('friendsList');
    if (savedFriends != null) {
      setState(() {
        addedFriends = List<Map<String, String>>.from(json
            .decode(savedFriends)
            .map((friend) => Map<String, String>.from(friend)));
      });
    }
  }

  Future<void> _saveFriends() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('friendsList', json.encode(addedFriends));
  }

  void _addNewFriend(Map<String, String> friend) {
    setState(() {
      if (!addedFriends.any((f) => f['phone'] == friend['phone'])) {
        addedFriends.add(friend);
        _saveFriends();
      }
    });
  }

  void _deleteFriend(int index) {
    setState(() {
      addedFriends.removeAt(index);
      _saveFriends();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Add Friends Icon
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person_add,
                          color: Colors.white, size: 40),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddFriendsScreen(onFriendAdded: _addNewFriend),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    const Text("Add Friends",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),

                // Search Icon (Navigates to SearchFriendsTab)
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: Colors.white, size: 40),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchFriendsTab(addedFriends: addedFriends),
                          ), // Navigate to search page
                        );
                      },
                    ),
                    const SizedBox(height: 5),
                    const Text("Search",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(
                width: double.infinity,
                child:
                    Divider(color: Colors.white, thickness: 1.5, height: 20)),
          ],
        ),
        Expanded(
          child: addedFriends.isEmpty
              ? const Center(
                  child: Text("No friends added yet",
                      style: TextStyle(color: Colors.white54, fontSize: 16)),
                )
              : ListView.builder(
                  itemCount: addedFriends.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            addedFriends[index]['avatarColor'] == 'blue'
                                ? Colors.blue
                                : Colors.purple,
                        child: Text(addedFriends[index]['initial']!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18)),
                      ),
                      title: Text(addedFriends[index]['name']!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      subtitle: Text(addedFriends[index]['description']!,
                          style: const TextStyle(color: Colors.white70)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteFriend(index);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
