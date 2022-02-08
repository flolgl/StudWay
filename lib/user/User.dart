class User {
  final int id;
  final String prenom;

  const User({
    required this.id,
    required this.prenom,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      prenom: json['prenom'],
    );
  }
}