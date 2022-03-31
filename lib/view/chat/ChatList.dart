import 'package:flutter/material.dart';
import 'package:studway_project/controller/conversation/Conversation.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:studway_project/view/utils/Utils.dart';

import 'components/ConversationView.dart';

class ChatList extends StatefulWidget{
  final User _user;

  const ChatList(this._user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatListState(_user);

}

/// Classe permettant d'afficher la page Messages d'un user
class _ChatListState extends State<ChatList>{
  final User _user;
  List<Conversation>? _conversations;

  _ChatListState(this._user);

  @override
  void initState() {
    super.initState();
    _getConversations();
  }

  void _getConversations() async{

    if (_user.conversations == null) {
      var convs = await _user.getUpdatedConversations();
      setState(() {
        _conversations = convs;
      });
    } else {
      setState(() {
        _conversations = _user.conversations;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _buildListConversationsView(),
    );
  }

  /// Retourne l'[AppBar] de la page affichant les conversations d'un user
  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Messages"),

    );
  }

  /// Retourne la vue de la liste des conversations d'un user
  /// @return Widget
  Widget _buildListConversationsView() {

    //print("called");
    if (_conversations == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    Widget widget = Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _conversations?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return _buildConversationView(context, index);
            },
          ),
        ),
      ],
    );
    return widget;
  }

  // TODO : timestamp du dernier msg de chaque conversation
  /// Retourne la vue d'une conversation
  /// @param context le contexte de la vue
  /// @param index l'index de la conversation
  /// @return la vue de la conversation
  /// @see Conversation
  Widget _buildConversationView(BuildContext context, int index) {
    final Conversation conv = _conversations![index];
    final destinaire = conv.members.firstWhere((u) => u.id != _user.id);
    return Container(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConversationView(conv))).then((value) => setState(() {
              _getConversations();
            }));
          },
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(destinaire.profilpic),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        destinaire.nom + " " + destinaire.prenom,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        conv.lastMessage.text,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  Utils.getDiff(conv.lastMessage.time, DateTime.now()).toString(),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}


