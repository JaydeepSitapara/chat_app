import 'package:first_app/api/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/message.dart';
import 'package:flutter/material.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;
  @override
  State<MessageCard> createState() {
    return _MessageCardState();
  }
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.instance.user.uid == widget.message.fromId
        ? senderMsg()
        : reciverMsg();
  }

  //sender
  Widget senderMsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 231, 233, 199),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ),
      ],
    );
  }

  //reciver
  Widget reciverMsg() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 182, 220, 225),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        ),
        const SizedBox(),
      ],
    );
  }
}
