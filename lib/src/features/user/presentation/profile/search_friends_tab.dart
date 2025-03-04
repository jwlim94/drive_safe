import 'package:drive_safe/src/shared/constants/app_colors.dart';
import 'package:drive_safe/src/shared/constants/text_styles.dart';
import 'package:flutter/material.dart';

class SearchFriendsTab extends StatefulWidget {
  const SearchFriendsTab({super.key, required this.addedFriends});
  final List<Map<String, dynamic>> addedFriends; // ✅ 타입 변경 (String -> dynamic)

  @override
  State<SearchFriendsTab> createState() => _SearchFriendsTabState();
}

class _SearchFriendsTabState extends State<SearchFriendsTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> filteredFriends = [];
  bool showDropdown = false;

  @override
  void initState() {
    super.initState();
    filteredFriends = List.from(widget.addedFriends);
  }

  void _searchFriends() {
    setState(() {
      filteredFriends = widget.addedFriends
          .where((friend) => (friend['name']?.toString() ?? "")
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
      showDropdown = false;
    });
  }

  void _updateDropdown(String value) {
    setState(() {
      showDropdown = value.isNotEmpty && filteredFriends.isNotEmpty;
      filteredFriends = widget.addedFriends
          .where((friend) => (friend['name']?.toString() ?? "")
              .toLowerCase()
              .startsWith(value.toLowerCase()))
          .toList();
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Input Field + Search Icon Button
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.customWhite, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      onChanged: _updateDropdown,
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
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _searchFriends,
                      splashRadius: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown Search Suggestions
            if (showDropdown && _searchController.text.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.customBlack,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.customWhite, width: 1),
                ),
                child: Column(
                  children: filteredFriends.map((friend) {
                    return ListTile(
                      title: Text(friend['name']?.toString() ?? "Unknown",
                          style: const TextStyle(color: Colors.white)),
                      onTap: () {
                        _searchController.text =
                            friend['name']?.toString() ?? "";
                        _searchFriends();
                      },
                    );
                  }).toList(),
                ),
              ),

            const SizedBox(height: 20),

            // 친구 리스트 + "Race" 버튼
            Expanded(
              child: ListView.builder(
                itemCount: filteredFriends.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          filteredFriends[index]['avatarColor'] == 'blue'
                              ? Colors.blue
                              : Colors.purple,
                      child: Text(
                        filteredFriends[index]['initial']?.toString() ?? "",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    title: Text(
                      filteredFriends[index]['name']?.toString() ?? "Unknown",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      filteredFriends[index]['description']?.toString() ?? "",
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
      ),
    );
  }
}
