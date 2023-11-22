import 'package:chat_app/widgets/button_with_leading_icon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInGoogle() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist =
        await firestore.collection('user').doc(userCredential.user!.uid).get();

    if (!userExist.exists) {
      await firestore.collection('user').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
      });
    } else {
      debugPrint("User Already Exists in Database");
    }

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXryqAQSASmyjn400_8wY-dkP3Kg2H-bhzbl_6LLXLG-KWI1repMVt2di4KM3Hp4LYdgg&usqp=CAU",
              ),
              fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              child: Text(
                "Welcome to Chat Himalaya",
                style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.black87, fontWeight: FontWeight.w800),
              ),
            ),
            const Spacer(),
            ButtonWithLeadingIcon(
              name: "Sign In With Google",
              iconImage:
                  "https://static-00.iconduck.com/assets.00/google-icon-2048x2048-czn3g8x8.png",
              function: () async {
                await signInGoogle();
              },
              backgroundColor: const Color.fromARGB(255, 183, 190, 200),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
