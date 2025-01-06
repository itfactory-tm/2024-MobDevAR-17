import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UserApi {
  static String server = '192.168.0.240:3000';

  static Future<List<User>> fetchUsers() async {
    var url = Uri.http(server, '/users');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((user) => User.fromJson(user)).toList();
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

  static Future<User?> fetchUser(int id) async {
    var url = Uri.http(server, '/users/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to fetch user with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user with ID $id: $e');
    }
    return null;
  }

  static Future<User?> createUser(User user) async {
    var url = Uri.http(server, '/users');
    try {
      final http.Response response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user),
      );
      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating user: $e');
    }
    return null; // Retourneer null bij een fout
  }

  static Future<User?> updateUser(int id, User user) async {
    var url = Uri.http(server, '/users/$id');
    try {
      final http.Response response = await http.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user),
      );
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      } else {
        print('Failed to update user with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user with ID $id: $e');
    }
    return null; // Retourneer null bij een fout
  }

  static Future<bool> deleteUser(int id) async {
    var url = Uri.http(server, '/users/$id');
    try {
      final http.Response response = await http.delete(url);
      if (response.statusCode == 200) {
        return true; // Verwijdering geslaagd
      } else {
        print('Failed to delete user with ID $id: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting user with ID $id: $e');
    }
    return false; // Retourneer false bij een fout
  }

  static Future<User?> loginUser(String username, String password) async {
    // Stel de queryparameters in
    var url =
        Uri.http(server, '/users', {'name': username, 'password': password});

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // De server retourneert direct de juiste gebruiker
        var userJson = jsonDecode(response.body);

        // Controleer of er een resultaat is
        if (userJson != null) {
          print(userJson);
          return User.fromJson(userJson.first);
        }
      } else {
        print('Fout bij het ophalen van de gebruiker: ${response.statusCode}');
      }
    } catch (e) {
      print('Fout bij het inloggen: $e');
    }

    return null;
  }

  static Future<User?> fetchUserByName(String name) async {
    var url = Uri.http(server, '/users', {'name': name});
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> usersJson = jsonDecode(response.body);

        if (usersJson.isNotEmpty) {
          var userJson = usersJson.first;
          return User.fromJson(userJson);
        }
      }
    } catch (e) {
      print('Fout bij het ophalen van de gebruiker: $e');
    }

    return null;
  }

  static Future<bool> addBeerToUser(int userId, int beerId) async {
    var url = Uri.http(server, '/users/$userId');

    try {
      // Fetch the user to get the current beers list
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> userJson = jsonDecode(response.body);

        // Check if the beers list already contains the beerId
        List<int> beers = List<int>.from(userJson['beers']);
        if (beers.contains(beerId)) {
          return false;
        }

        beers.add(beerId);
        userJson['beers'] = beers;

        final updateResponse = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userJson),
        );

        if (updateResponse.statusCode == 200) {
          print("Successfully added Beer ID $beerId to the user.");
          return true;
        } else {
          print("Failed to update the user: ${updateResponse.statusCode}");
        }
      } else {
        print("Failed to fetch user: ${response.statusCode}");
      }
    } catch (e) {
      print("Error adding beer to user: $e");
    }

    return false;
  }
}
