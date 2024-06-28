import 'dart:io';

import 'package:flutter/material.dart';
import 'package:plantjake/favoriteitem.dart';

class FavoriteDetail extends StatelessWidget {
  final FavoriteItem favoriteItem;

  const FavoriteDetail({super.key, required this.favoriteItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar tanaman
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
                          File(favoriteItem
                              .imagePath), // Tampilkan gambar dari imagePath
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0), // Jarak antara gambar dan info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Judul tanaman
                        Text(
                          favoriteItem.label,
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
                          '${favoriteItem.confidence.toStringAsFixed(2)}%',
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
                favoriteItem.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
