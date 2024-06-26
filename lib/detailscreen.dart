import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantjake/favoriteitem.dart';

class DetailScreen extends StatelessWidget {
  final String label;
  final String description;
  final double confidence;

  const DetailScreen({
    super.key,
    required this.label,
    required this.description,
    required this.confidence,
  });

  Future<void> _saveToFavorites(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing favorites from SharedPreferences
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];

    // Add new favorite item
    FavoriteItem favoriteItem = FavoriteItem(
        label: label, description: description, confidence: confidence);
    favoriteItemsJson.add(favoriteItem.toJson());

    // Save updated list back to SharedPreferences
    await prefs.setStringList('favorite_items', favoriteItemsJson);

    // Show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saved to favorites!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hasil Deteksi',
          style: TextStyle(
            fontFamily: "Baloo2",
            fontSize: 30,
            color: Color(0xFF1A4D2E),
            height: 2.0,
          ),
        ),
        // toolbarHeight: 80,
        automaticallyImplyLeading: false, // Disable back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 5),
            const Text(
              'Jenis Tanaman :', // Display confidence with two decimal places
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Baloo2",
                color: Color(0xFF1A4D2E),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Hasil Prediksi :', // Display confidence with two decimal places
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Baloo2",
                color: Color(0xFF1A4D2E),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${confidence.toStringAsFixed(2)}%', // Display confidence with two decimal places
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deskripsi :', // Display confidence with two decimal places
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: "Baloo2",
                color: Color(0xFF1A4D2E),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description, // Display plant description
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
            const Spacer(), // Spacer to push buttons to the bottom
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle close button press
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F6F52),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 50), // Spacer between buttons
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle save favorite button press
                    _saveToFavorites(context);
                  },
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Simpan ke Favorite',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A4D2E),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
