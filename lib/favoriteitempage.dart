import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plantjake/favoriteitem.dart';
import 'package:plantjake/favoritedetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteItemPage extends StatefulWidget {
  const FavoriteItemPage({super.key});

  @override
  FavoriteItemPageState createState() {
    return FavoriteItemPageState();
  }
}

class FavoriteItemPageState extends State<FavoriteItemPage> {
  List<FavoriteItem> favoriteItems = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];
    setState(() {
      favoriteItems = favoriteItemsJson
          .map((itemJson) => FavoriteItem.fromJson(itemJson))
          .toList();
    });
  }

  Future<void> _deleteFavorite(int index) async {
    setState(() {
      favoriteItems.removeAt(index);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        favoriteItems.map((item) => item.toJson()).toList();
    await prefs.setStringList('favorite_items', favoriteItemsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          'Favorit',
          style: TextStyle(
            fontFamily: "Baloo2",
            fontSize: 30,
            color: Color(0xFF1A4D2E),
            height: 2.0,
          ),
        ),
        toolbarHeight: 80,
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text(
                'Belum ada tanaman favorit-mu disini, ayo kita cari',
                style: TextStyle(
                  fontFamily: "Baloo2",
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final favoriteItem = favoriteItems[index];
                return Dismissible(
                  key: Key(favoriteItem.label),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _deleteFavorite(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${favoriteItem.label} deleted'),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: AlignmentDirectional.centerEnd,
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                  child: Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Container(
                        width: 70,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          // ignore: unnecessary_null_comparison
                          child: favoriteItem.imagePath != null
                              ? Image.file(
                                  File(favoriteItem.imagePath),
                                  width: 70,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(
                                  Icons.image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      title: Text(favoriteItem.label),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${favoriteItem.confidence.toStringAsFixed(2)}%',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy HH:mm')
                                .format(favoriteItem.dateSaved),
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FavoriteDetail(favoriteItem: favoriteItem),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
