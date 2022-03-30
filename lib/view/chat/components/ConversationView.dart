import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:studway_project/controller/conversation/Conversation.dart';
import 'package:studway_project/controller/conversation/Message.dart';
import 'package:studway_project/controller/user/User.dart';

import 'MessageView.dart';

class ConversationView extends StatefulWidget {
  final Conversation _conv;

  const ConversationView(this._conv, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationViewState(_conv);
}

// TODO : Faire une vraie vue de conversation
class _ConversationViewState extends State<ConversationView> {
  final Conversation _conversation;
  List<Message>? messages;
  late IO.Socket _socket;

  _ConversationViewState(this._conversation);

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _socket = User.currentUser!.socket;
    getConversationMsg();
  }

  void getConversationMsg() async {
    var msg = await _conversation.getMessages();
    setState(() {
      messages = msg;
    });
    _socket.on('newMsg', (data) {
      if (data['convId'] == _conversation.id) {
        setState(() {
          var newMsg = messages;
          newMsg!.add(Message(data["content"], DateTime.now(), data["from"]));
          messages = newMsg;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildListMessagesView(context),
      bottomNavigationBar: buildMessageInputBar(),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: Text(_conversation.members[0].id == User.currentUser!.id
          ? _conversation.members[1].nom + " " + _conversation.members[1].prenom
          : _conversation.members[0].nom +
              " " +
              _conversation.members[0].prenom),
    );
  }

  // build the conversation view

  // a chat view is composed of a list of messages and a text field to send a message to the conversation partner (the other user)
  @override
  Widget _buildListMessagesView(BuildContext context) {
    if (messages == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: <Widget>[
          // TODO : Afficher les messages
          ListView.builder(
            shrinkWrap: true,
            itemCount: messages!.length,
            itemBuilder: (context, index) {
              return MessageView(
                  messages![index].text,
                  messages![index].idSender == User.currentUser!.id,
                  index == messages!.length,
                  messages![index]);
            },
          ),
        ],
      ),
    );
  }

  Padding buildMessageInputBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message',
              ),
              onSubmitted: (text) {
                _conversation.sendMessage(text);
                setState(() {
                  var newMsg = messages;
                  newMsg!.add(Message(
                      text, DateTime.now(), User.currentUser!.id));
                  messages = newMsg;
                });
                _controller.clear();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              _conversation.sendMessage(_controller.text);
              setState(() {
                var newMsg = messages;
                newMsg!.add(Message(_controller.text, DateTime.now(),
                    User.currentUser!.id));
                messages = newMsg;
              });
              _controller.clear();
            },
          ),
        ],
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text(_conversation.members.elementAt(0).prenom),
//     ),
//     body: Container(
//       child: Text(_conversation.lastMessage.text),
//     ),
//   );
// }
}
