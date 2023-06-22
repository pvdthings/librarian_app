class ThingModel {
  ThingModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory ThingModel.fromJson(Map<String, dynamic> json) {
    return ThingModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}
