import 'dart:convert';

class Collection {
  final String cAddress;
  final String name;
  final String image;
  final String creator;
  final String metadata;
  final int volumeOfEth;

  const Collection({
    required this.cAddress,
    required this.name,
    required this.image,
    required this.creator,
    required this.metadata,
    required this.volumeOfEth,
  });

  Collection copyWith({
    String? cAddress,
    String? name,
    String? image,
    String? creator,
    String? metadata,
    int? volumeOfEth,
  }) {
    return Collection(
      cAddress: cAddress ?? this.cAddress,
      name: name ?? this.name,
      image: image ?? this.image,
      creator: creator ?? this.creator,
      metadata: metadata ?? this.metadata,
      volumeOfEth: volumeOfEth ?? this.volumeOfEth,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cAddress': cAddress,
      'name': name,
      'image': image,
      'creator': creator,
      'metadata': metadata,
      'volumeOfEth': volumeOfEth,
    };
  }

  factory Collection.fromMap(Map<String, dynamic> map) {
    return Collection(
      cAddress: map['cAddress'],
      name: map['name'],
      image: map['image'],
      creator: map['creator'],
      metadata: map['metadata'],
      volumeOfEth: map['volumeOfEth'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Collection.fromJson(String source) =>
      Collection.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Collection(cAddress: $cAddress, name: $name, image: $image, creator: $creator, metadata: $metadata, volumeOfEth: $volumeOfEth)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Collection &&
        other.cAddress == cAddress &&
        other.name == name &&
        other.image == image &&
        other.creator == creator &&
        other.metadata == metadata &&
        other.volumeOfEth == volumeOfEth;
  }

  @override
  int get hashCode {
    return cAddress.hashCode ^
        name.hashCode ^
        image.hashCode ^
        creator.hashCode ^
        metadata.hashCode ^
        volumeOfEth.hashCode;
  }
}
