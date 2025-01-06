import 'package:flutter/material.dart';
import 'package:beer_explorer/pages/ar_page.dart';
import 'package:beer_explorer/pages/beer_list.dart';
import 'package:beer_explorer/pages/info.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Keeps track of the selected index

  // List of pages to navigate between
  final List<Widget> _pages = [
    const InfoPage(),
    const ArPage(),
    const BeerListPage()
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
        backgroundColor: Colors.blueAccent, // A clean color for the AppBar
        elevation: 0,
      ),
      body: Material(
        color: const Color.fromARGB(255, 76, 203, 203),
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.list),
            label: 'Collection',
          ),
        ],
        // Customize the appearance of the navigation bar
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
    );
  }
}
