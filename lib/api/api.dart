import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_app/models/chat_user.dart';

class APIs {
  //authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for current user
  static User get user => auth.currentUser!;

  //for checking if user is exist or not
  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //create new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      image: user.photoURL.toString(),
      about: 'hey WE CHAT',
      name: user.displayName.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      id: user.uid,
      email: user.email.toString(),
      pushToken: '',
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }
}
