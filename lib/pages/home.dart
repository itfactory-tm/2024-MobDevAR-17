import 'package:beer_explorer/pages/ar_page.dart';
import 'package:beer_explorer/pages/info.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Keeps track of the selected index

  // List of pages to navigate between
  final List<Widget> _pages = [
    const InfoPage(title: "BeerExplorer", description: "hello world!"),
    const ArPage(),
    const InfoPage(title: "BeerExplorer", description: "hello world3!")
  ];

  // This function will handle the bottom navigation tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BeerExplorer"),
      ),
      body: Material(
        color: const Color.fromARGB(255, 76, 203, 203),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.camera), label: 'Scan'),
          NavigationDestination(icon: Icon(Icons.home), label: 'Home3'),
        ],
      ),
    );
  }
}
