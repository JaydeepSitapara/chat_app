import 'package:first_app/api/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/models/message.dart';
import 'package:first_app/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.user});
  final ChatUser user;
  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name ?? ''),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: APIs.instance.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: SizedBox(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => Message.fromJson(e.data())).toList() ??
                            [];

                    if (_list.isNotEmpty) {
                      return ListView.builder(
                        itemCount: _list.length,
                        itemBuilder: (context, index) {
                          return MessageCard(
                            message: _list[index],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text(
                          'Say Hello',
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
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: mq.height * .01,
              vertical: mq.width * .03,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                      child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: 'Send a msg..',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (textController.text.isNotEmpty) {
                            APIs.instance.sendMessage(
                              widget.user,
                              textController.text,
                            );
                            textController.text = '';
                          }
                        },
                        icon: const Icon(Icons.send),
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
