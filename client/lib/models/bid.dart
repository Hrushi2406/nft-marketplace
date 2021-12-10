import 'dart:convert';

import 'dart:math';

class Bid {
  final String? cAddress;
  final int? tokenId;
  final String from;
  final double price;

  const Bid({
    this.cAddress,
    this.tokenId,
    required this.from,
    required this.price,
  });

  Bid copyWith({
    String? cAddress,
    int? tokenId,
    String? from,
    double? price,
  }) {
    return Bid(
      cAddress: cAddress ?? this.cAddress,
      tokenId: tokenId ?? this.tokenId,
      from: from ?? this.from,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cAddress': cAddress,
      'tokenId': tokenId,
      'from': from,
      'price': price,
    };
  }

  factory Bid.fromMap(Map<String, dynamic> map) {
    return Bid(
      from: map['from'] ?? '',
      price: map['price'] / pow(10, 6) ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Bid.fromJson(String source) => Bid.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Bid(cAddress: $cAddress, tokenId: $tokenId, from: $from, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Bid &&
        other.cAddress == cAddress &&
        other.tokenId == tokenId &&
        other.from == from &&
        other.price == price;
  }

  @override
  int get hashCode {
    return cAddress.hashCode ^
        tokenId.hashCode ^
        from.hashCode ^
        price.hashCode;
  }
}
