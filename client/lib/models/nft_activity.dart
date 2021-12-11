import 'dart:convert';

import 'dart:math';

class NFTActivity {
  final String id;
  final String eventType;
  final String from;
  final String to;
  final double price;
  final String timestamp;

  const NFTActivity({
    required this.id,
    required this.eventType,
    required this.from,
    required this.to,
    required this.price,
    required this.timestamp,
  });

  NFTActivity copyWith({
    String? id,
    String? eventType,
    String? from,
    String? to,
    double? price,
    String? timestamp,
  }) {
    return NFTActivity(
      id: id ?? this.id,
      eventType: eventType ?? this.eventType,
      from: from ?? this.from,
      to: to ?? this.to,
      price: price ?? this.price,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eventType': eventType,
      'from': from,
      'to': to,
      'price': price,
      'timestamp': timestamp,
    };
  }

  factory NFTActivity.fromMap(Map<String, dynamic> map) {
    return NFTActivity(
      id: map['id'],
      eventType: map['eventType'],
      from: map['from'],
      to: map['to'],
      price: map['price'] / pow(10, 6),
      timestamp: map['timestamp'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NFTActivity.fromJson(String source) =>
      NFTActivity.fromMap(json.decode(source));

  @override
  String toString() {
    return 'NFTActivity(id: $id, eventType: $eventType, from: $from, to: $to, price: $price, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NFTActivity &&
        other.id == id &&
        other.eventType == eventType &&
        other.from == from &&
        other.to == to &&
        other.price == price &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        eventType.hashCode ^
        from.hashCode ^
        to.hashCode ^
        price.hashCode ^
        timestamp.hashCode;
  }
}
