import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';

import 'thing_model.dart';

class InventoryViewModel extends ChangeNotifier {
  InventoryViewModel() {
    refresh();
  }

  final _repository = InventoryRepository();

  List<ThingModel> get things => _repository.things;

  String? _selectedId;

  ThingModel? get selected => _selectedId != null
      ? things.firstWhere((t) => t.id == _selectedId)
      : null;

  List<ThingModel> filtered(String filter) {
    if (filter.isEmpty) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  void select(ThingModel thing) {
    _selectedId = thing.id;
    notifyListeners();
  }

  void clearSelection() {
    _selectedId = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _repository.refresh();
    notifyListeners();
  }
}
