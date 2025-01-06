import 'package:flutter/material.dart';
import '../models/user.dart';
import '../apis/user_api.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  User? user;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = User(
        id: 0, name: "", password: "", email: "", beers: [], likedBeers: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Logo or title area (optional)
              const Center(
                child: Icon(
                  Icons.app_registration,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),

              // Name field
              TextField(
                controller: firstnameController,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Enter your full name",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email field
              TextField(
                controller: emailController,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Enter your email",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              TextField(
                controller: passwordController,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: "Enter your password",
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.7),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: _saveUser,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveUser() async {
    // Vul de gebruiker in met de gegevens uit de velden
    user!.name = firstnameController.text.trim();
    user!.password = passwordController.text.trim();
    user!.email = emailController.text.trim();

    if (user!.id == 0) {
      // Controleer of er al een gebruiker bestaat met dezelfde naam
      final existingUser = await UserApi.fetchUserByName(user!.name);

      if (existingUser != null) {
        // Toon een foutmelding als de gebruiker al bestaat
        _showErrorDialog("User already exists");
        return;
      }

      // Maak de gebruiker aan als de naam niet bestaat
      UserApi.createUser(user!).then((result) {
        Navigator.pop(context, true);
      });
    }
  }

  // Foutmelding bij het al bestaan van de gebruiker
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
