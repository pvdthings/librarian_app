class DetailedThingModel {
  DetailedThingModel({
    required this.id,
    required this.name,
    required this.items,
    required this.stock,
    required this.available,
    this.spanishName,
  });

  final String id;
  final String name;
  final String? spanishName;
  final int stock;
  final int available;
  final List<ItemModel> items;

  factory DetailedThingModel.fromJson(Map<String, dynamic> json) {
    return DetailedThingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      spanishName: json['name_es'] as String?,
      stock: json['stock'] as int,
      available: json['available'] as int,
      items: (json['items'] as List).map((e) => ItemModel.fromJson(e)).toList(),
    );
  }
}

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
