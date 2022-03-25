class Conversation{
  int id;
  String name;
  String avatar;
  String lastMessage;
  String time;
  int unread;
  bool isGroup;
  List<String> members;
  Conversation(this.id, this.name, this.avatar, this.lastMessage, this.time, this.unread, this.isGroup, this.members);

  static Future<List<Conversation>> fromJsonList(decode) {
    return decode.map((e) => Conversation.fromJson(e)).toList();
  }

  static fromJson(e) {
    return Conversation(
      e['id'],
      e['name'],
      e['avatar'],
      e['lastMessage'],
      e['time'],
      e['unread'],
      e['isGroup'],
      e['members']
    );
  }

}