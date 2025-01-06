import 'package:beer_explorer/models/beer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BeerApi {
  // static String server = '192.168.0.240:3000';
  static String server = '192.168.0.70:3000';

  static Future<List<Beer>> fetchBeers() async {
    var url = Uri.http(server, '/beers');

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
    var url = Uri.http(server, '/beers/$id');
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
    var url = Uri.http(server, '/beers', {'name': name});
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
        var url = Uri.http(server, '/beers/$id');
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

  static Future<List<Beer>> getLikedBeers(int userId) async {
    var url = Uri.http(server, '/users/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> userJson = jsonDecode(response.body);
        List<int> likedBeersIds = List<int>.from(userJson['likedBeers']);

        // Fetch the beers using their IDs
        List<Beer> likedBeers = [];
        for (var beerId in likedBeersIds) {
          Beer? beer = await BeerApi.fetchBeerById(beerId);
          if (beer != null) {
            likedBeers.add(beer);
          }
        }

        return likedBeers;
      } else {
        print("Failed to fetch liked beers: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching liked beers: $e");
    }

    return []; // Return an empty list on failure
  }

 static Future<List<Beer>> fetchTopBeers() async {
    var url = Uri.http(server, '/beers/top');  // Zorg ervoor dat de server dit endpoint ondersteunt

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((beer) => Beer.fromJson(beer)).toList();
      } else {
        // Foutafhandelingscode als de statuscode niet 200 is
        print('Failed to load top beers: ${response.statusCode}');
        return [];  // Retourneer een lege lijst als het ophalen van de bieren mislukt
      }
    } catch (e) {
      print('Error fetching top beers: $e');
      return [];  // Retourneer een lege lijst bij een netwerkfout
    }
  }
}