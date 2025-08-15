class PriceItem {
  final String package;
  final double price;
  final String tag;
  final String buttonLabel;

  PriceItem({
    required this.package,
    required this.price,
    required this.tag,
    required this.buttonLabel,
  });

  factory PriceItem.fromMap(Map<String, dynamic> map) {
    return PriceItem(
      package: map['package'] ?? '',
      price: (map['price'] is num) ? map['price'].toDouble() : double.tryParse(map['price'].toString()) ?? 0.0,
      tag: map['tag'] ?? '',
      buttonLabel: map['buttonLabel'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package': package,
      'price': price,
      'tag': tag,
      'buttonLabel': buttonLabel,
    };
  }
}
