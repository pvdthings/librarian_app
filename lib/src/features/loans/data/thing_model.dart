class ThingModel {
  final String id;
  final int number;
  String? name;
  bool available;

  ThingModel({
    required this.id,
    required this.number,
    required this.name,
    this.available = true,
  });
}
