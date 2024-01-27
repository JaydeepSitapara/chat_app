import 'package:first_app/api/api.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Icon(Icons.home),
        title: const Text('We Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder(
        stream: APIs.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list = data!.map((e) => ChatUser.fromJson(e.data())).toList();

              if (list.isNotEmpty) {
                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return ChatUserCard(
                      user: list[index],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No user Found!',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                );
              }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await APIs.auth.signOut();
          await GoogleSignIn().signOut();
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
