import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantjake/favoriteitem.dart';

class FavoriteService {
  // Menyimpan item favorit ke SharedPreferences
  static Future<void> saveFavorite(FavoriteItem favoriteItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];

    // Konversi favoriteItem ke JSON dan tambahkan ke daftar
    favoriteItemsJson.add(favoriteItem.toJson());

    await prefs.setStringList('favorite_items', favoriteItemsJson);
  }

  // Menghapus item favorit dari SharedPreferences berdasarkan label
  static Future<void> removeFavorite(String label) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];

    // Hapus item berdasarkan label
    favoriteItemsJson.removeWhere((itemJson) {
      Map<String, dynamic> itemMap = json.decode(itemJson);
      return itemMap['label'] == label;
    });

    await prefs.setStringList('favorite_items', favoriteItemsJson);
  }

  // Mengambil daftar semua item favorit dari SharedPreferences
  static Future<List<FavoriteItem>> getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];

    // Konversi JSON ke objek FavoriteItem
    List<FavoriteItem> favoriteItems = favoriteItemsJson
        .map((itemJson) => FavoriteItem.fromJson(itemJson))
        .toList();

    return favoriteItems;
  }
}
