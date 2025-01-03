import 'package:beer_explorer/models/beer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BeerApi {
  static String server = 'nice-tools-swim.loca.lt';

  static Future<List<Beer>> fetchBeers() async {
    var url = Uri.https(server, '/beers');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => Beer.fromJson(user)).toList();
      } else {
        // Log een waarschuwing bij een niet-succesvolle statuscode
        print('Failed to load users: ${response.statusCode}');
        return []; // Retourneer een lege lijst
      }
    } catch (e) {
      // Foutafhandeling voor netwerkproblemen of andere uitzonderingen
      print('Error fetching users: $e');
      return []; // Retourneer een lege lijst als fallback
    }
  }

  static Future<Beer?> fetchBeerById(int id) async {
    var url = Uri.https(server, '/beers/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Beer.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch user with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user with ID $id: $e');
    }
    return null; // Retourneer null bij een fout
  }

  static Future<Beer?> fetchBeerByName(String name) async {
    // Voeg de queryparameter toe aan de URL
    var url = Uri.https(server, '/beers', {'name': name});
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> beersJson = jsonDecode(response.body);

        if (beersJson.isNotEmpty) {
          return Beer.fromJson(beersJson.first);
        }
      } else {
        print('Failed to fetch beer by name: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching beer by name: $e');
    }
    return null;
  }

  static Future<List<Beer>> fetchBeersByIds(List<int> ids) async {
    List<Beer> beers = [];
    try {
      for (int id in ids) {
        var url = Uri.https(server, '/beers/$id');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          var beerJson = jsonDecode(response.body);
          beers.add(Beer.fromJson(beerJson));
        } else {
          print('Failed to fetch beer with ID $id: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error fetching beers: $e');
    }
    return beers;
  }
}
