import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:plantjake/favoriteitem.dart';

class DetailScreen extends StatelessWidget {
  final String label;
  final String description;
  final double confidence;
  final String imagePath;

  const DetailScreen({
    super.key,
    required this.label,
    required this.description,
    required this.confidence,
    required this.imagePath,
  });

  Future<void> _saveToFavorites(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load existing favorites from SharedPreferences
    List<String> favoriteItemsJson =
        prefs.getStringList('favorite_items') ?? <String>[];

    // Add new favorite item
    FavoriteItem favoriteItem = FavoriteItem(
      label: label,
      description: description,
      confidence: confidence,
      dateSaved: DateTime.now(),
      imagePath: imagePath, // Use imagePath directly (nullable)
    );
    favoriteItemsJson.add(favoriteItem.toJson());

    // Save updated list back to SharedPreferences
    await prefs.setStringList('favorite_items', favoriteItemsJson);

    // Show snackbar
    // ignore: use_build_context_synchronously
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
        automaticallyImplyLeading: false, // Disable back button
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ignore: unnecessary_null_comparison
                        if (imagePath !=
                            null) // Conditionally display the image
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: SizedBox(
                                width: 150,
                                height: 150,
                                child: Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                            width: 16.0), // Jarak antara gambar dan info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Judul tanaman
                              Text(
                                label,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'baloo2',
                                  color: Color(
                                      0xFF1A4D2E), // Mengatur warna teks menjadi hijau
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              // Hasil Prediksi
                              const Text(
                                'Hasil Prediksi :',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${confidence.toStringAsFixed(2)}%',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Deskripsi tanaman
                    const Text(
                      'Deskripsi',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'baloo2',
                        color: Color(0xFF1A4D2E), // Warna font
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
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
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  onPressed: () {
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
                      horizontal: 30,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
