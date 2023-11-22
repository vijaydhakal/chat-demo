import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';
import 'chat_screen.dart';

class SearchScreen extends StatefulWidget {
  final UserModel user;
  const SearchScreen(this.user, {super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(title: const Text("Search People")),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: 'Search...'),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('user')
                  .where(
                    'name',
                    isNotEqualTo: widget.user.name,
                  )
                  .snapshots(),
              builder: (context, snapshots) {
                return (snapshots.connectionState == ConnectionState.waiting)
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: snapshots.data!.docs.length,
                        itemBuilder: (context, index) {
                          var data = snapshots.data!.docs[index].data()
                              as Map<String, dynamic>;
                          if (name.isEmpty ||
                              data['name']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(name.toLowerCase())) {
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatScreen(
                                            currentUser: widget.user,
                                            friendId: data['uid'],
                                            friendName: data['name'],
                                            friendImage: data['image'])));
                              },
                              title: Text(
                                data['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.titleMedium,
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(data['image']),
                              ),
                            );
                          }
                          return Center(
                            child: Text("No Data Available",
                                style: textTheme.titleMedium),
                          );
                        });
              },
            )),
          ],
        ));
  }
}
