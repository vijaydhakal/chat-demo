import 'package:chat_app/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import 'chat_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen(this.user, {super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('user')
              .doc(widget.user.uid)
              .collection('messages')
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.length < 1) {
                return const Center(
                  child: Text(
                      "No Chats Available! You can search and message your friend"),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    var friendId = snapshot.data.docs[index].id;
                    var lastMsg = snapshot.data.docs[index]['last_msg'];
                    var a = DateTime.parse(
                        snapshot.data.docs[index]['date'].toDate().toString());
                    var time = DateFormat(' hh:mm a').format(a);

                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('user')
                          .doc(friendId)
                          .get(),
                      builder: (context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          var friend = asyncSnapshot.data;
                          return ListTile(
                            leading: Container(
                              margin: const EdgeInsets.only(),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  friend['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(
                              friend['name'],
                              style: textTheme.titleMedium,
                            ),
                            trailing: Text(
                              time,
                              style: textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              "$lastMsg",
                              style: const TextStyle(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                          currentUser: widget.user,
                                          friendId: friend['uid'],
                                          friendName: friend['name'],
                                          friendImage: friend['image'])));
                            },
                          );
                        }
                        return const LinearProgressIndicator();
                      },
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchScreen(widget.user)));
        },
      ),
    );
  }
}
