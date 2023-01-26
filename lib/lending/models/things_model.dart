import 'package:flutter/material.dart';

class ThingsModel extends ChangeNotifier {
  List<Thing> getAll() {
    return const [
      Thing(id: 1, name: "Pokédex", available: false),
      Thing(id: 2, name: "Hammer"),
      Thing(id: 3, name: "Something else"),
    ];
  }
}

class Thing {
  final String name;
  final int id;
  final bool available;

  const Thing({
    required this.name,
    required this.id,
    this.available = true,
  });
}
