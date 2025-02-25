import 'package:drive_safe/src/features/user/presentation/profile/add_friends_tab.dart';
import 'package:drive_safe/src/features/user/presentation/profile/search_friends_tab.dart';
import 'package:flutter/material.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({super.key});

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  List<Map<String, dynamic>> addedFriends = []; // 추가된 친구 목록 저장

  /// 친구 추가 함수
  void _addFriend(Map<String, dynamic> friend) {
    setState(() {
      addedFriends.add(friend);
    });
  }

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
                          onFriendAdded: _addFriend, // 친구 추가 시 상태 업데이트
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
                          addedFriends: addedFriends,
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
        Expanded(
          child: addedFriends.isEmpty
              ? const Center(
                  child: Text(
                    "No friends added yet",
                    style: TextStyle(color: Colors.white54, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  itemCount: addedFriends.length,
                  itemBuilder: (context, index) {
                    final friend = addedFriends[index];
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
                    );
                  },
                ),
        ),
      ],
    );
  }
}
