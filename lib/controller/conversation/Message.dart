class Message {
  String text;
  String time;
  String sender;
  String type;
  Message(this.text, this.time, this.sender, this.type);
  static fromJson(e) {
    return Message(
        e['text'],
        e['time'],
        e['sender'],
        e['type']
    );
  }
}