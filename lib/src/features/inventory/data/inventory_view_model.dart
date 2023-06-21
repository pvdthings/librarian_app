import 'package:flutter/material.dart';

class InventoryViewModel extends ChangeNotifier {
  List<ThingModel> _things = [];

  List<ThingModel> filtered(String filter) {
    if (filter.isEmpty) {
      return _things;
    }

    return _things;
  }

  ThingModel? _selected;

  ThingModel? get selected => _selected;

  void select(ThingModel thing) {
    _selected = thing;
    notifyListeners();
  }

  void clearSelection() {
    _selected = null;
    notifyListeners();
  }
}

class ThingModel {
  ThingModel({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
}
