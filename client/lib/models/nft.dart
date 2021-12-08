import 'dart:convert';

class NFT {
  final String name;
  final String cAddress;
  final int tokenId;
  final String image;
  final String collectionName;
  final String creator;
  final String owner;
  final String metadata;

  const NFT({
    required this.name,
    required this.cAddress,
    required this.tokenId,
    required this.image,
    required this.collectionName,
    required this.creator,
    required this.owner,
    required this.metadata,
  });

  NFT copyWith({
    String? name,
    String? cAddress,
    int? tokenId,
    String? image,
    String? collectionName,
    String? creator,
    String? owner,
    String? metadata,
  }) {
    return NFT(
      name: name ?? this.name,
      cAddress: cAddress ?? this.cAddress,
      tokenId: tokenId ?? this.tokenId,
      image: image ?? this.image,
      collectionName: collectionName ?? this.collectionName,
      creator: creator ?? this.creator,
      owner: owner ?? this.owner,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cAddress': cAddress,
      'tokenId': tokenId,
      'image': image,
      'collectionName': collectionName,
      'creator': creator,
      'owner': owner,
      'metadata': metadata,
    };
  }

  factory NFT.fromMap(Map<String, dynamic> map) {
    return NFT(
      name: map['name'],
      cAddress: map['cAddress'],
      tokenId: map['tokenId'],
      image: map['image'],
      collectionName: map['collectionName'],
      creator: map['creator'],
      owner: map['owner'],
      metadata: map['metadata'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFT.fromJson(String source) => NFT.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NFT(name: $name, cAddress: $cAddress, tokenId: $tokenId, image: $image, collectionName: $collectionName, creator: $creator, owner: $owner, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NFT &&
        other.name == name &&
        other.cAddress == cAddress &&
        other.tokenId == tokenId &&
        other.image == image &&
        other.collectionName == collectionName &&
        other.creator == creator &&
        other.owner == owner &&
        other.metadata == metadata;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        cAddress.hashCode ^
        tokenId.hashCode ^
        image.hashCode ^
        collectionName.hashCode ^
        creator.hashCode ^
        owner.hashCode ^
        metadata.hashCode;
  }
}
