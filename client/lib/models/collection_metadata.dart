import 'dart:convert';

class CollectionMetaData {
  final String name;
  final String symbol;
  final String description;
  final String twitterUrl;
  final String websiteUrl;
  final String image;

  const CollectionMetaData({
    required this.name,
    required this.symbol,
    required this.description,
    required this.twitterUrl,
    required this.websiteUrl,
    required this.image,
  });

  factory CollectionMetaData.initEmpty() {
    return const CollectionMetaData(
      name: '',
      symbol: '',
      description: 'Loading Description....',
      twitterUrl: '',
      websiteUrl: '',
      image: '',
    );
  }

  CollectionMetaData copyWith({
    String? name,
    String? symbol,
    String? description,
    String? twitterUrl,
    String? websiteUrl,
    String? image,
  }) {
    return CollectionMetaData(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      description: description ?? this.description,
      twitterUrl: twitterUrl ?? this.twitterUrl,
      websiteUrl: websiteUrl ?? this.websiteUrl,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'symbol': symbol,
      'description': description,
      'twitterUrl': twitterUrl,
      'websiteUrl': websiteUrl,
      'image': image,
    };
  }

  factory CollectionMetaData.fromMap(Map<String, dynamic> map) {
    return CollectionMetaData(
      name: map['name'],
      symbol: map['symbol'],
      description: map['description'],
      twitterUrl: map['twitterUrl'],
      websiteUrl: map['websiteUrl'],
      image: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CollectionMetaData.fromJson(String source) =>
      CollectionMetaData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CollectionMetaData(name: $name, symbol: $symbol, description: $description, twitterUrl: $twitterUrl, websiteUrl: $websiteUrl, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CollectionMetaData &&
        other.name == name &&
        other.symbol == symbol &&
        other.description == description &&
        other.twitterUrl == twitterUrl &&
        other.websiteUrl == websiteUrl &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        symbol.hashCode ^
        description.hashCode ^
        twitterUrl.hashCode ^
        websiteUrl.hashCode ^
        image.hashCode;
  }
}
