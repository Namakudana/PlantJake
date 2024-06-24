import 'dart:convert';

class FavoriteItem {
   String label;
   double confidence;
   String description;

  FavoriteItem({
    required this.label,
    required this.confidence,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'description': description,
    };
  }

  factory FavoriteItem.fromMap(Map<String, dynamic> map) {
    return FavoriteItem(
      label: map['label'],
      confidence: map['confidence'] is int ? (map['confidence'] as int).toDouble() : map['confidence'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FavoriteItem.fromJson(String source) =>
      FavoriteItem.fromMap(json.decode(source));
}
