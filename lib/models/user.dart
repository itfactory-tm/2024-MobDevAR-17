class User {
  int id;
  String email;
  String name;
  String password;
  List<int> beers;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.beers});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        password: json['password'],
        beers: List<int>.from(json['beers'].map((x) => x as int)));
  }

  Map<String, dynamic> toJson() =>
      {'email': email, 'name': name, 'password': password, 'beers': beers};
}
