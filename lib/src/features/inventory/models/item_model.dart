class ItemModel {
  ItemModel({
    required this.id,
    required this.number,
    required this.name,
    required this.available,
    required this.hidden,
    required this.totalLoans,
    this.brand,
    this.condition,
    this.description,
    this.estimatedValue,
  });

  final String id;
  final int number;
  final String name;
  final String? description;
  final String? brand;
  final String? condition;
  final double? estimatedValue;
  final bool available;
  final bool hidden;
  final int totalLoans;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      number: json['number'] as int,
      name: json['name'] as String? ?? 'Unknown Thing',
      description: json['description'] as String?,
      available: json['available'] as bool,
      hidden: json['hidden'] as bool,
      totalLoans: json['totalLoans'] as int,
      brand: json['brand'] as String?,
      condition: json['condition'] as String?,
      estimatedValue: json['estimatedValue'] as double?,
    );
  }
}
