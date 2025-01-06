import 'package:beer_explorer/apis/beer_api.dart';
import 'package:beer_explorer/globals.dart';
import 'package:beer_explorer/models/beer.dart';
import 'package:flutter/material.dart';
import '../apis/user_api.dart';

class BeerListPage extends StatefulWidget {
  const BeerListPage({super.key});

  @override
  State<StatefulWidget> createState() => _BeerListPageState();
}

class _BeerListPageState extends State<BeerListPage> {
  List<Beer> beerList = [];
  List<Beer> filteredBeerList = [];
  List<Beer> likedBeers = []; // New list to store liked beers
  int count = 0;
  String _sortOption = 'Alphabetical'; // Default sort option
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getBeers();
    _searchController.addListener(_filterBeers); // Listen for changes in the search field
    _getLikedBeers(); // Fetch liked beers initially
  }

  // Fetch liked beers from the server
  void _getLikedBeers() async {
    if (currentUser != null) {
      List<Beer> beers = await UserApi.getLikedBeers(currentUser!.id);
      setState(() {
        likedBeers = beers;
      });
    }
  }

  void _getBeers() async {
    if (currentUser != null) {
      List<Beer> beers = await BeerApi.fetchBeersByIds(currentUser!.beers);
      setState(() {
        beerList = beers;
        filteredBeerList = beers; // Initially show all beers
        count = beers.length;
        _sortBeers(); // Sort the beers initially
      });
    }
  }

  void _sortBeers() {
    setState(() {
      if (_sortOption == 'Alphabetical') {
        filteredBeerList.sort((a, b) => a.name.compareTo(b.name));
      } else if (_sortOption == 'Rating') {
        filteredBeerList.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_sortOption == 'Liked') {
        filteredBeerList = likedBeers; // Show only liked beers
      }
    });
  }

  void _filterBeers() {
    setState(() {
      if (_searchController.text.isEmpty) {
        filteredBeerList = beerList;
      } else {
        filteredBeerList = beerList
            .where((beer) => beer.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
      count = filteredBeerList.length; // Update the count based on filtered beers
    });
  }

  void _toggleLike(Beer beer) {
    setState(() {
      if (likedBeers.contains(beer)) {
        likedBeers.remove(beer); // Remove the beer from liked beers list
        UserApi.removeLikedBeerFromUser(currentUser!.id, beer.id); // Remove from server
      } else {
        likedBeers.add(beer); // Add the beer to liked beers list
        UserApi.addLikedBeerToUser(currentUser!.id, beer.id); // Add to server
      }
      _sortBeers(); // Reapply the sorting after like status changes
    });
  }

 @override
  Widget build(BuildContext context) {
    // Check if beerList is empty (still loading), show a loading indicator if so
    if (beerList.isEmpty) {
      return const Center(child: CircularProgressIndicator()); // Show loading if beerList is empty
    }

    // Check if sorting by liked beers and there are no liked beers
    if (_sortOption == 'Liked' && likedBeers.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Explored Beers"),
          actions: [
            DropdownButton<String>(
              value: _sortOption,
              items: const [
                DropdownMenuItem(
                  value: 'Alphabetical',
                  child: Text('Sort by Name'),
                ),
                DropdownMenuItem(
                  value: 'Rating',
                  child: Text('Sort by Rating'),
                ),
                DropdownMenuItem(
                  value: 'Liked',
                  child: Text('Show Liked Beers'),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _sortOption = newValue;
                    _sortBeers(); // Apply sorting when option changes
                  });
                }
              },
              icon: const Icon(Icons.sort, color: Colors.white),
              dropdownColor: Colors.grey.shade400,
              underline: Container(),
            ),
          ],
        ),
        body: Center(
          child: Text(
            "No liked beers yet.",
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
        ),
      );
    }

    // Default screen when beers are available
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explored Beers"),
        actions: [
          DropdownButton<String>(
            value: _sortOption,
            items: const [
              DropdownMenuItem(
                value: 'Alphabetical',
                child: Text('Sort by Name'),
              ),
              DropdownMenuItem(
                value: 'Rating',
                child: Text('Sort by Rating'),
              ),
              DropdownMenuItem(
                value: 'Liked',
                child: Text('Show Liked Beers'),
              ),
            ],
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _sortOption = newValue;
                  _sortBeers(); // Apply sorting when option changes
                });
              }
            },
            icon: const Icon(Icons.sort, color: Colors.white),
            dropdownColor: Colors.grey.shade400,
            underline: Container(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search by Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(child: _beerListItems()),
          ],
        ),
      ),
    );
  }

  ListView _beerListItems() {
    // Controleren of de lijst leeg is en een bericht weergeven
    if (filteredBeerList.isEmpty) {
      return ListView(
        children: [
          Center(
            child: Text(
              _sortOption == 'Liked' && likedBeers.isEmpty
                  ? "No liked beers yet."
                  : "No beers available.",
              style: TextStyle(fontSize: 18.0, color: Colors.grey),
            ),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: filteredBeerList.length, // gebruik de lengte van de filteredBeerList
      itemBuilder: (BuildContext context, int position) {
        final beer = filteredBeerList[position]; // Toegang tot het bier op de juiste index
        final double rating = beer.rating;

        Color getRatingColor(double rating) {
          if (rating >= 4.0) {
            return Colors.green;
          } else if (rating >= 2.5 && rating < 4.0) {
            return Colors.orange;
          } else {
            return Colors.red;
          }
        }

        return Card(
          color: Colors.white,
          elevation: 2.0,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      beer.name,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      "Brewery: ${beer.brewery}",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      beer.description,
                      style: const TextStyle(fontSize: 14.0),
                    ),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          likedBeers.contains(beer)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: likedBeers.contains(beer)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          _toggleLike(beer); // Toggle like
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: getRatingColor(rating),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}