import 'package:flutter/material.dart';

class ThingsModel extends ChangeNotifier {
  static final _things = [
    Thing(id: 1, name: "Pokédex"),
    Thing(id: 2, name: "Pokéball"),
    Thing(id: 3, name: "Pokéball"),
    Thing(id: 4, name: "Bug net"),
    Thing(id: 5, name: "Incubator"),
  ];

  List<Thing> getAll() => _things;

  void checkOut(int id) {
    _things.singleWhere((t) => t.id == id).available = false;
    notifyListeners();
  }

  void checkIn(int id) {
    _things.singleWhere((t) => t.id == id).available = true;
    notifyListeners();
  }
}

class Thing {
  final String name;
  final int id;
  bool available;

  Thing({
    required this.name,
    required this.id,
    this.available = true,
  });
}
