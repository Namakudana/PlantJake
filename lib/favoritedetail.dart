import 'package:flutter/material.dart';
import 'package:plantjake/favoriteitem.dart';

class FavoriteDetail extends StatelessWidget {
  final FavoriteItem favoriteItem;

  const FavoriteDetail({super.key, required this.favoriteItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        // title: Text(favoriteItem.label), // Gunakan favoriteItem.label di sini
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
              favoriteItem.label,
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
              '${favoriteItem.confidence.toStringAsFixed(2)}%',
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
              favoriteItem.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
