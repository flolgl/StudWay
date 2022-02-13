class User {
  final int _id;
  final int _nbMsg;
  final String _prenom;

  User(this._id, this._nbMsg, this._prenom);


  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['nbMsg'],
      json['prenom'],
    );
  }

  int get id => _id;
  int get nbMsg => _nbMsg;
  String get prenom => _prenom;
}