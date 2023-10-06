class ThingSummaryModel {
  final String id;
  final String name;
  final int number;

  const ThingSummaryModel({
    required this.id,
    required this.name,
    required this.number,
  });

  factory ThingSummaryModel.fromJson(Map<String, dynamic> json) {
    return ThingSummaryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as int,
    );
  }
}
