class Response {
  final String code;
  final String error;
  final List<BeerResponse> data;

  Response({required this.code, required this.error, required this.data});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      code: json['code'],
      error: json['error'],
      data: (json['data'] as List)
          .map((beerJson) => BeerResponse.fromJson(beerJson))
          .toList(),
    );
  }
}

class BeerResponse {
  final String sku;
  final String name;
  final String brewery;
  final String rating;
  final String description;
  final String country;

  BeerResponse({
    required this.sku,
    required this.name,
    required this.brewery,
    required this.rating,
    required this.description,
    required this.country,
  });

  factory BeerResponse.fromJson(Map<String, dynamic> json) {
    return BeerResponse(
      sku: json['sku'],
      name: json['name'],
      brewery: json['brewery'],
      rating: json['rating'],
      description: json['description'],
      country: json['country'],
    );
  }
}
