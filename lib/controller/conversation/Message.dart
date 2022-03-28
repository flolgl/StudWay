class Message {
  final String text;
  final DateTime time;
  final int idSender;
  Message(this.text, this.time, this.idSender);

  static fromJson(e) {
    return Message(
        e['Message'],
        e['DateEnvoie'] != null
            ? DateTime.parse(e['DateEnvoie'])
            : DateTime.now(),
        e['idUtilisateur'],
    );
  }

  static List<Message> fromJsonList(jsonDecode) {
    List<Message> list = <Message>[];
    for (var e in jsonDecode) {
      list.add(Message.fromJson(e));
    }
    return list;
  }


}