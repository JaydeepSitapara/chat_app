import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/models/message.dart';

class APIs {
  static final APIs instance = APIs._internal();

  initListeners() {
    authState.listen((user) {
      // print('AuthState: ${user?.uid}');
      if (user != null) {
        me = ChatUser(id: user.uid);
        getSelfInfo();
      }
    });
  }

  Stream<User?> get authState => auth.authStateChanges();

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
  ChatUser? me;

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

  //for getting current user info
  void getSelfInfo() {
    print('me : ${user.displayName}');
    firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        // print('UserExits: ${user.id}');
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

  ///************ Message Screen ***************///

  String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id.toString())}/messages/')
        .snapshots();
  }

  // for sending message
  Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
  ) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatUser.id.toString(),
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref = firestore.collection(
        'chats/${getConversationID(chatUser.id.toString())}/messages/');
    await ref.doc(time).set(message.toJson());
  }
}
