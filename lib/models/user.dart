class User {
  int id;
  String email;
  String name;
  String password;
  List<int> beers;
  List<int> likedBeers;

  User(
      {required this.id,
      required this.email,
      required this.name,
      required this.password,
      required this.beers, 
      required this.likedBeers});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        email: json['email'],
        name: json['name'],
        password: json['password'],
        beers: List<int>.from(json['beers'].map((x) => x as int)),
        likedBeers: List<int>.from(json['beers'].map((x) => x as int)));
  }

  Map<String, dynamic> toJson() =>
      {'email': email, 'name': name, 'password': password, 'beers': beers, 'likedBeers': likedBeers};
}
