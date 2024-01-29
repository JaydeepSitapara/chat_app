import 'package:first_app/api/api.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/screens/profile_screen.dart';
import 'package:first_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   List<ChatUser> _list = [];
  final List<ChatUser> _searchedList = [];
  var _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: const Icon(Icons.home),
            title: _isSearching
                ? TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Name, Email',
                    ),
                    style: const TextStyle(
                      fontSize: 17.0,
                      letterSpacing: 1.0,
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      _searchedList.clear();

                      for (var i in _list) {
                        if (i.name
                                .toLowerCase()
                                .contains(value.toLowerCase()) ||
                            i.email
                                .toLowerCase()
                                .contains(value.toLowerCase())) {
                          _searchedList.add(i);
                        }
                        setState(() {
                          _searchedList;
                        });
                      }
                    },
                  )
                : const Text('We Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                  });
                },
                icon: _isSearching
                    ? const Icon(CupertinoIcons.clear_circled_solid)
                    : const Icon(Icons.search),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: StreamBuilder(
            stream: APIs.instance.getAllUsers(),
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
                  _list =
                      data!.map((e) => ChatUser.fromJson(e.data())).toList();

                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:
                          _isSearching ? _searchedList.length : _list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: _isSearching
                              ? _searchedList[index]
                              : _list[index],
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
        ),
      ),
    );
  }
}
