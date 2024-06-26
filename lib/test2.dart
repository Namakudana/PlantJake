import 'package:flutter/material.dart';
import 'package:plantjake/model.dart';

class DetailPlant extends StatelessWidget {
  final Plant plant;

  const DetailPlant({super.key, required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text(
          //   plant.label ,
          // ),
          ),
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
                        child: Image.network(
                          plant.imageUrl,
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
                          plant.label,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'baloo2',
                            color: Color(
                                0xFF1A4D2E), // Mengatur warna teks menjadi hijau
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        // Nama ilmiah tanaman (resume)
                        const Text(
                          'Botanical Name :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          plant.resume,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16.0),
                        // Tipe tanaman
                        const Text(
                          'Type :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          plant.type,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Deskripsi tanaman
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'baloo2',
                  color: Color(0xFF1A4D2E), // Warna font
                ),
              ),
              const SizedBox(height: 20),
              // Deskripsi tanaman
              Text(
                plant.description,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize:
                      16, // Ganti dengan nama font family yang Anda gunakan
                ),
              ),
              const SizedBox(height: 30),
              // Deskripsi tanaman
              const Text(
                'Kandungan',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'baloo2',
                  color: Color(0xFF1A4D2E), // Warna font
                ),
              ),
              const SizedBox(height: 20),
              // Deskripsi tanaman
              Text(
                plant.benefit,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize:
                      16, // Ganti dengan nama font family yang Anda gunakan
                ),
              ),
              const SizedBox(height: 30),
              // Deskripsi tanaman
              const Text(
                'Manfaat',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'baloo2',
                  color: Color(0xFF1A4D2E), // Warna font
                ),
              ),
              const SizedBox(height: 20),
              // Deskripsi tanaman
              Text(
                plant.content,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize:
                      16, // Ganti dengan nama font family yang Anda gunakan
                ),
              ),
              const SizedBox(height: 30),
              // Deskripsi tanaman
              const Text(
                'Penggunaan',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'baloo2',
                  color: Color(0xFF1A4D2E), // Warna font
                ),
              ),
              const SizedBox(height: 20),
              // Deskripsi tanaman
              Text(
                plant.use,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize:
                      16, // Ganti dengan nama font family yang Anda gunakan
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
