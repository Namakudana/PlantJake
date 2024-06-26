import 'package:flutter/material.dart';
import 'package:plantjake/test2.dart';
import 'package:plantjake/plantdata.dart';

class PlantList extends StatelessWidget {
  const PlantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          'Artikel',
          style: TextStyle(
              fontFamily: "Baloo2",
              fontSize: 30,
              color: Color(0xFF1A4D2E),
              height: 2.0),
        ),
        toolbarHeight: 80,
        // elevation: 5, // Menambahkan bayangan dengan elevation
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Card(
            color: Colors.white, // Ubah warna latar belakang Card menjadi putih
            child: ListTile(
              title: Text(plant.label),
              subtitle: Text(plant.resume),
              leading: Image.network(plant.imageUrl),
              trailing: const Icon(Icons.arrow_forward_rounded),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPlant(plant: plant),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
