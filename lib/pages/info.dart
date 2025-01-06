import 'package:beer_explorer/models/beer.dart';
import 'package:beer_explorer/pages/login_page.dart';
import 'package:beer_explorer/pages/register.dart';
import 'package:flutter/material.dart';
import 'package:beer_explorer/globals.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final String title = "BeerExplorer";
  final String description =
      "Welcome to our BeerExplorer app! \nHere you can scan a new beer and save it with a rating. ";
  final Icon icon = const Icon(Icons.home, size: 32, color: Colors.greenAccent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome!"),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton.icon(
            onPressed: _navigateToRegister,
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: const Text(
              "Register",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.green,
            ),
          ),
          const SizedBox(width: 8), // Kleine ruimte tussen de knoppen
          ElevatedButton.icon(
            onPressed: _navigateToLogin,
            icon: const Icon(Icons.login, color: Colors.white),
            label: const Text(
              "Login",
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  icon,
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              // Controleer of de user gedefinieerd is
              currentUser != null
                  ? Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.green[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "Welcome back, ${currentUser!.name}!",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    )
                  : Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.red[50],
                      child: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          "You need to log in to access more features.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
    setState(() {}); // Update de UI na terugkomst
  }

  void _navigateToLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
    setState(() {}); // Update de UI na terugkomst
  }
}
