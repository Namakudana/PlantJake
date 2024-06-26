import 'dart:convert';

class FavoriteItem {
  String label;
  double confidence;
  String description;
  DateTime dateSaved;
  // String imageUrl; // Tambahkan properti imageUrl

  FavoriteItem({
    required this.label,
    required this.confidence,
    required this.description,
    required this.dateSaved, // Update constructor untuk menyertakan dateSaved
    // required this.imageUrl, // Update constructor untuk menyertakan imageUrl
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'description': description,
      'dateSaved': dateSaved
          .toIso8601String(), // Ensure dateSaved is set to current date and time
      // 'imageUrl': imageUrl,
      // 'dateSaved': DateTime.now(), // Ensure dateSaved is set to current date and time
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      label: map['label'],
      confidence: map['confidence'] is int
          ? (map['confidence'] as int).toDouble()
          : map['confidence'],
      description: map['description'],
      // imageUrl: map['imageUrl'],
      dateSaved: DateTime.parse(
          map['dateSaved']), // Deserialize String ISO 8601 to DateTime
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteItem.fromJson(String source) =>
      FavoriteItem.fromMap(json.decode(source));
}
