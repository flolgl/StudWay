import 'package:studway_project/controller/user/User.dart';

import 'Message.dart';

class Conversation{
  int id;
  String name;
  String lastMessage;
  DateTime time;
  List<User> members;
  Conversation(this.id, this.name, this.lastMessage, this.time, this.members);

  static Future<List<Conversation>> fromJsonList(List<dynamic> decode) async {
    List<Conversation> list = <Conversation>[];
    for (var i = 0; i < decode.length; i++) {
      list.add(await Conversation.fromJson(decode[i]));
    }
    return list;
  }

  static Future<Conversation> fromJson(Map<String, dynamic> e) async {
    var userA = await User.fetchStrictUserInfo(e["idUtilisateurA"]);
    var userB = await User.fetchStrictUserInfo(e["idUtilisateurB"]);
    var users = [userA, userB];
    return Conversation(
      e['idConversation'],
      e['Libelle'],
      e['Message'],
      DateTime.parse(e['read_at']),
      users
    );
  }

}