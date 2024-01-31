import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/chat_user.dart';
import 'package:first_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() {
    return _ChatUserCardState();
  }
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) =>  ChatScreen(user: widget.user),
            ),
          );
        },
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(mq.height * .3),
            child: CachedNetworkImage(
              imageUrl: widget.user.image ?? '',
              width: mq.height * .055,
              height: mq.height * .055,
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          // leading: const CircleAvatar(
          //   child: Icon(Icons.person_2),
          // ),
          title: Text(widget.user.name ?? ''),
          subtitle: Text(
            widget.user.about ?? '',
            maxLines: 1,
          ),
          // trailing: const Text('02.00 PM'),
          trailing: Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
