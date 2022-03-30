import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:studway_project/controller/user/User.dart';
import 'package:http/http.dart' as http;

import 'Message.dart';

class Conversation{
  final int id;
  final String name;
  Message lastMessage;
  DateTime time;
  final List<User> members;
  late List<Message> messages;
  Conversation(this.id, this.name, this.lastMessage, this.time, this.members);

  static Future<List<Conversation>> fromJsonList(List<dynamic> decode) async {
    List<Conversation> list = <Conversation>[];
    for (var i = 0; i < decode.length; i++) {
      list.add(await Conversation.fromJson(decode[i]));
    }
    return list;
  }

  // fetch conversation messages
  

  static Future<Conversation> fromJson(Map<String, dynamic> e) async {

    var userA = await User.fetchStrictUserInfo(e["idUtilisateurA"]);
    var userB = await User.fetchStrictUserInfo(e["idUtilisateurB"]);
    var users = [userA, userB];
    Message lastMsg;
    if (e["Message"] == null){
      lastMsg = Message("", DateTime.now(), User.currentUser!.id);
    }else{
      lastMsg = Message(e["Message"], DateTime.parse(e["DateEnvoi"]), e["idUtilisateur"]);
    }
    return Conversation(
      e['idConversation'],
      e['Libelle'],
      lastMsg,
      lastMsg.time,
      users
    );
  }

  void addMessage(String content, int senderId) {
    messages.add(Message(content, DateTime.now(), senderId));
  }

  void addMessageFromMessage(Message msg) {
    messages.add(msg);
  }


  Future<List<Message>> getMessages() async{
    final prefs = await SharedPreferences.getInstance();
    messages = [];

    final response = await http.get( Uri.parse("http://localhost:3000/message/conversation/$id/${User.currentUser!.id}"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token')}"
    });


    if (response.statusCode == 200) {
      messages.addAll(Message.fromJsonList(jsonDecode(response.body)));
    }
    //messages.forEach((message) => print(message.text));
    return messages;
  }

  void sendMessage(String s) {

    var user = User.currentUser;
    user!.sendNewMsg(id, user.id == members.first.id ? members.last.id : members.first.id , s);
  }

  static Future<Conversation> createConversation(User user, User user2, int idAnnonce, String libelle) async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse("http://localhost:3000/conversation/create/${user.id}"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer ${prefs.getString('token')}"
    }, body: jsonEncode({
      "idUtilisateurDestinataire": user2.id,
      "idAnnonce": idAnnonce,
      "libelle": libelle,
    }));

    print(response.body);
    if (response.statusCode == 200) {
      return Conversation.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to create conversation');
  }


}