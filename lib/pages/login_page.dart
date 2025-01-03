import 'package:beer_explorer/globals.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../apis/user_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;

  TextEditingController firstnameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = User(id: 0, name: "", password: "", email: "", beers: []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _userDetails(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loginUser,
        label: const Text("Login"),
        icon: const Icon(Icons.login),
      ),
    );
  }

  _userDetails() {
    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      TextStyle? textStyle = Theme.of(context).textTheme.bodyText1;

      firstnameController.text = user!.name;
      passwordController.text = user!.password;

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: firstnameController,
              style: textStyle,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Username",
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
              obscureText: true, // Hide password text
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

  void _loginUser() {
    user!.name = firstnameController.text;
    user!.password = passwordController.text;

    UserApi.loginUser(user!.name, user!.password).then((user) {
      if (user != null) {
        currentUser = user;
        Navigator.pop(context, true);
      } else {
        // Show error if login fails
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Incorrect username or password.'),
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
    });
  }
}
