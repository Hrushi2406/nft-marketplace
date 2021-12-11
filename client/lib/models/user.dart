import 'dart:convert';

import 'package:web3dart/web3dart.dart';

class User {
  final String name;
  final EthereumAddress uAddress;
  final String metadata;
  final String image;

  const User({
    required this.name,
    required this.uAddress,
    required this.metadata,
    required this.image,
  });

  factory User.initEmpty(String address) => User(
        name: 'Unamed',
        uAddress: EthereumAddress.fromHex(address),
        metadata: '',
        image: 'QmWTq1mVjiBp6kPXeT2XZftvsWQ6nZwSBvTbqKLumipMwD',
      );

  User copyWith({
    String? name,
    EthereumAddress? uAddress,
    String? metadata,
    String? image,
  }) {
    return User(
      name: name ?? this.name,
      uAddress: uAddress ?? this.uAddress,
      metadata: metadata ?? this.metadata,
      image: image ?? this.image,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uAddress': uAddress.hex,
      'metadata': metadata,
      'image': image,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? 'Unamed',
      uAddress: EthereumAddress.fromHex(map['uAddress']),
      metadata: map['metadata'] ?? '',
      image: map['image'] ??
          'bafybeid3njd5agpz7a3mloo3q5cdcmtvo7o3uab6hhwongfck23ycv3uyy',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(name: $name, uAddress: $uAddress, metadata: $metadata, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.name == name &&
        other.uAddress == uAddress &&
        other.metadata == metadata &&
        other.image == image;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        uAddress.hashCode ^
        metadata.hashCode ^
        image.hashCode;
  }
}
