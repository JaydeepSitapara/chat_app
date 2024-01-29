import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/models/chat_user.dart';

class APIs {
  static final APIs instance = APIs._internal();

  initListeners() {
    auth.authStateChanges().listen((user) {
      if (user != null) {
        getSelfInfo();
      }
    });
  }

  APIs._internal() {
    initListeners();
  }
  //authentication
  FirebaseAuth auth = FirebaseAuth.instance;

  // firestore database
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // firebase
  FirebaseStorage storage = FirebaseStorage.instance;

  //for storing current user info of type ChatUser MODEL
  late ChatUser? me;

  //for current user
  User get user => auth.currentUser!;

  //for checking if user is exist or not
  Future<bool> userExists() async {
    DocumentSnapshot<Map<String, dynamic>> result =
        (await firestore.collection('users').doc(user.uid).get());
    if (result.exists) {
      me = ChatUser.fromJson(result.data()!);
    }

    return result.exists;
  }

  //for getting current user ingo
  void getSelfInfo() {
    firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
      }
    });
  }

  //create new user
  Future<void> createUser() async {
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

    me = chatUser;

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  //return all chat user
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //update profile info
  Future<void> updateProfileInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me!.name,
      'about': me!.about,
    }); // <-- Updated data
  }

  //for store profile picture
  Future<void> updateProfilePicture(File file) async {
    final ref = storage.ref().child('profile_pictures${user.uid}.jpg');
    ref
        .putFile(file, SettableMetadata(contentType: 'image/jpg'))
        .then((p0) async {
      
      me!.image = await ref.getDownloadURL();
      
      await firestore.collection('users').doc(user.uid).update({
        'image': me!.image,
      });
    });
  }
}
