class Beer {
  final int id;
  final String name;
  final String brewery;
  final double rating;
  final String description;
  final List<String> countries;

  Beer({
    required this.id,
    required this.name,
    required this.brewery,
    required this.rating,
    required this.description,
    required this.countries,
  });

  factory Beer.fromJson(Map<String, dynamic> json) {
    return Beer(
        id: json['id'],
        name: json['name'],
        brewery: json['brewery'],
        rating: json['rating'],
        description: json['description'],
        countries:
            List<String>.from(json['countries'].map((x) => x as String)));
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'brewery': brewery,
        'rating': rating,
        'description': description,
        'countries': countries
      };
}
