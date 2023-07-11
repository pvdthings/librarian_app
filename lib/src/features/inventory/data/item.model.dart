class ItemModel {
  ItemModel({
    required this.id,
    required this.number,
    required this.available,
    required this.totalLoans,
    this.brand,
  });

  final String id;
  final int number;
  final String? brand;
  final bool available;
  final int totalLoans;

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      number: json['number'] as int,
      available: json['available'] as bool,
      totalLoans: json['totalLoans'] as int,
      brand: json['brand'] as String?,
    );
  }
}