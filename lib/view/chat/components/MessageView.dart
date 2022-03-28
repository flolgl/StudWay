import 'package:flutter/material.dart';
import 'package:studway_project/controller/conversation/Message.dart';

import '../../AppTheme.dart';

class MessageView extends StatelessWidget{
  final String message;
  final Message msg;
  final bool isMe;
  final bool isLastMessage;

  const MessageView(this.message, this.isMe, this.isLastMessage, this.msg, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 84
          ),
          margin: EdgeInsets.only(
            top: 5,
            bottom: isLastMessage ? 20 : 5,
            left: 16,
            right: 16,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            color: isMe ? AppTheme.normalBlue : Colors.black26,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}