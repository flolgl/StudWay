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
    print(e);
    var userA = await User.fetchStrictUserInfo(e["idUtilisateurA"]);
    var userB = await User.fetchStrictUserInfo(e["idUtilisateurB"]);
    var users = [userA, userB];
    return Conversation(
      e['idConversation'],
      e['Libelle'],
      Message(e["Message"], DateTime.parse(e["DateEnvoi"]), e["idUtilisateur"]),
      DateTime.parse(e['read_at']),
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
    messages.forEach((message) => print(message.text));
    return messages;
  }

  void sendMessage(String s) {

    var user = User.currentUser;
    user!.sendNewMsg(id, user.id == members.first.id ? members.last.id : members.first.id , s);
  }

}