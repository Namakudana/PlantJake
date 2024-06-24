import 'dart:convert';

class FavoriteItem {
  final String label;
  final String description;
  final double confidence; // Mengubah tipe data confidence menjadi double

  FavoriteItem({
    required this.label,
    required this.description,
    required this.confidence,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'description': description,
      'confidence': confidence,
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      label: map['label'],
      description: map['description'],
      confidence: map['confidence'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteItem.fromJson(String source) =>
      FavoriteItem.fromMap(json.decode(source));
}
