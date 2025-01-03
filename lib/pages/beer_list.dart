import 'package:beer_explorer/apis/beer_api.dart';
import 'package:beer_explorer/globals.dart';
import 'package:beer_explorer/models/beer.dart';
import 'package:flutter/material.dart';
import '../apis/user_api.dart';
import 'user_detail.dart';

class BeerListPage extends StatefulWidget {
  const BeerListPage({super.key});

  @override
  State<StatefulWidget> createState() => _BeerListPageState();
}

class _BeerListPageState extends State {
  List<Beer> beerList = [];
  int count = 0;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  void _getUsers() {
    if (currentUser != null) {
      BeerApi.fetchBeersByIds(currentUser!.beers).then((beers) => {
            setState(() {
              beerList = beers;
              count = beers.length;
            })
          });
    }
  }

  // void _navigateToDetail(int id) async {
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => UserDetailPage(id: id)),
  //   );

  //   _getUsers();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explored beers"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _beerListItems(),
      ),
    );
  }

  ListView _beerListItems() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text(beerList[position].name.substring(0, 1)),
            ),
            title: Text(
                "${beerList[position].name} ${beerList[position].brewery}"),
            subtitle: Text(beerList[position].description),
            onTap: () {
              // _navigateToDetail(beerList[position].id);
            },
          ),
        );
      },
    );
  }
}
