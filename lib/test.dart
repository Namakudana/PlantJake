import 'package:flutter/material.dart';
import 'package:plantjake/test2.dart';
import 'package:plantjake/plantdata.dart';

class PlantList extends StatelessWidget {
  const PlantList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant List'),
      ),
      body: ListView.builder(
        itemCount: plants.length,
        itemBuilder: (context, index) {
          final plant = plants[index];
          return Card(
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
