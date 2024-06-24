import 'package:flutter/material.dart';
import 'package:plantjake/favoritedetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantjake/favoriteitem.dart';
import 'package:plantjake/favoriteservice.dart' show FavoriteService; // Ensure this import is correct

class FavoriteItemPage extends StatefulWidget {
  const FavoriteItemPage({super.key});

  @override
  FavoriteItemPageState createState() {
    return FavoriteItemPageState();
  }
}

class FavoriteItemPageState extends State<FavoriteItemPage> {
  List<FavoriteItem> favoriteItems = [];
  FavoriteService favoriteService = FavoriteService(); // Instantiate FavoriteService

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];
    print('Saved favorite items: $favoriteItemsJson');
    setState(() {
      favoriteItems = favoriteItemsJson
          .map((itemJson) => FavoriteItem.fromJson(itemJson))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Items'),
      ),
      body: ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          final favoriteItem = favoriteItems[index];
          return ListTile(
            title: Text(favoriteItem.label),
            subtitle: Text('${favoriteItem.confidence.toStringAsFixed(2)}%'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteDetail(favoriteItem: favoriteItem),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
