import 'package:flutter/material.dart';
import 'package:plantjake/favoriteitem.dart';

class FavoriteDetail extends StatelessWidget {
  final FavoriteItem favoriteItem;

  const FavoriteDetail({super.key, required this.favoriteItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              favoriteItem.label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${favoriteItem.confidence.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              favoriteItem.description,
              style: const TextStyle(
                fontSize: 18,
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
