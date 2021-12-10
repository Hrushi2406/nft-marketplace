import 'dart:convert';

import 'package:flutter/foundation.dart';

class NFTMetadata {
  final String name;
  final String description;
  final String image;
  final List<Map<String, dynamic>> properties;

  const NFTMetadata({
    required this.name,
    required this.description,
    required this.image,
    required this.properties,
  });

  factory NFTMetadata.initEmpty() => const NFTMetadata(
        name: '',
        description: 'loading decription..',
        image: '',
        properties: [],
      );

  NFTMetadata copyWith({
    String? name,
    String? description,
    String? image,
    List<Map<String, dynamic>>? properties,
  }) {
    return NFTMetadata(
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      properties: properties ?? this.properties,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'image': image,
      'properties': properties,
    };
  }

  factory NFTMetadata.fromMap(Map<String, dynamic> map) {
    return NFTMetadata(
      name: map['name'],
      description: map['description'],
      image: map['image'],
      properties:
          List<Map<String, dynamic>>.from(map['properties']?.map((x) => x)),
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTMetadata.fromJson(String source) =>
      NFTMetadata.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NFTMetadata(name: $name, description: $description, image: $image, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NFTMetadata &&
        other.name == name &&
        other.description == description &&
        other.image == image &&
        listEquals(other.properties, properties);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        description.hashCode ^
        image.hashCode ^
        properties.hashCode;
  }
}
