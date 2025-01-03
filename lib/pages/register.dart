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
    user = User(id: 0, name: "", password: "", email: "", beers: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _userDetails(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveUser,
        label: const Text("Save"),
        icon: const Icon(Icons.save),
      ),
    );
  }

  _userDetails() {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      TextStyle? textStyle = Theme.of(context).textTheme.bodyLarge;

      firstnameController.text = user!.name;
      passwordController.text = user!.password;
      emailController.text = user!.email;

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: firstnameController,
              style: textStyle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Name",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              style: textStyle,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              style: textStyle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: textStyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _saveUser() async {
    // Vul de gebruiker in met de gegevens uit de velden
    user!.name = firstnameController.text.trim();
    user!.password = passwordController.text.trim();
    user!.email = emailController.text.trim();
    user!.beers = [1];

    if (user!.id == 0) {
      // Controleer of er al een gebruiker bestaat met dezelfde naam
      final existingUser = await UserApi.fetchUserByName(user!.name);

      if (existingUser != null) {
        return;
      }

      // Maak de gebruiker aan als de naam niet bestaat
      UserApi.createUser(user!).then((result) {
        Navigator.pop(context, true);
      });
    }
  }
}
