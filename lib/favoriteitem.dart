import 'dart:convert';

class FavoriteItem {
  String label;
  double confidence;
  String description;
  DateTime dateSaved;
  String imagePath; // Tambahkan properti imagePath

  FavoriteItem({
    required this.label,
    required this.confidence,
    required this.description,
    required this.dateSaved, // Update constructor untuk menyertakan dateSaved
    required this.imagePath, // Tambahkan imagePath pada constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'description': description,
      'dateSaved': dateSaved
          .toIso8601String(), // Ensure dateSaved is set to current date and time
      'imagePath': imagePath, // Tambahkan imagePath ke dalam map
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      label: map['label'],
      confidence: map['confidence'] is int
          ? (map['confidence'] as int).toDouble()
          : map['confidence'],
      description: map['description'],
      dateSaved: DateTime.parse(
          map['dateSaved']), // Deserialize String ISO 8601 to DateTime
      imagePath: map['imagePath'], // Deserialize imagePath
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteItem.fromJson(String source) =>
      FavoriteItem.fromMap(json.decode(source));
}
