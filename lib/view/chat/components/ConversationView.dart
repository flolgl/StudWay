import 'package:flutter/material.dart';
import 'package:studway_project/controller/conversation/Conversation.dart';

// TODO : Faire une vraie vue de conversation
class ConversationView extends StatelessWidget {
  final Conversation _conversation;

  const ConversationView(this._conversation, {Key? key}) : super(key: key);

  // build the conversation view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_conversation.members.elementAt(0).prenom),
      ),
      body: Container(
        child: Text(_conversation.lastMessage),
      ),
    );
  }
}
