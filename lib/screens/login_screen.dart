import 'dart:io' show InternetAddress;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/Screens/home_screen.dart';
import 'package:first_app/api/api.dart';
import 'package:first_app/helper/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  _handleGoogleBtnClick() {
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      Navigator.of(context).pop();
      if (user != null) {
        //if user exists move to home screen
        if (await APIs.instance.userExists()) {
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomeScreen(),
            ),
          );
        } else {
          // craete user and move to home screen
          await APIs.instance.createUser().then(
            (value) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomeScreen(),
                ),
              );
            },
          );
        }
      }
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.instance.auth.signInWithCredential(credential);
    } catch (e) {
      // print('_signInWithGoogle : $e');
      // ignore: use_build_context_synchronously
      Dialogs.showSnackbar(context, 'Something want wrong..');
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Welcome to We Chat'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: mq.height * .15,
            left: mq.width * .25,
            width: mq.width * .5,
            child: Image.asset('assets/images/chat.png'),
          ),
          Positioned(
            bottom: mq.height * .15,
            left: mq.width * .05,
            width: mq.width * .9,
            height: mq.height * .07,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 221, 225, 193),
                shape: const StadiumBorder(),
                elevation: 1.0,
              ),
              icon: const Icon(Icons.add),
              onPressed: _handleGoogleBtnClick,
              label: RichText(
                text: const TextSpan(
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    children: [
                      TextSpan(text: 'Sign In '),
                      TextSpan(
                        text: 'Google ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
