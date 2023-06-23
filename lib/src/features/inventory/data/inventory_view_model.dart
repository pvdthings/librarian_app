import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';

import 'thing_model.dart';

class InventoryViewModel extends ChangeNotifier {
  InventoryViewModel() {
    refresh();
  }

  final _repository = InventoryRepository();

  List<ThingModel> get things => _repository.things;

  String? selectedId;

  ThingModel? get selected =>
      selectedId != null ? things.firstWhere((t) => t.id == selectedId) : null;

  List<ThingModel> filtered(String filter) {
    if (filter.isEmpty) {
      return things;
    }

    return things
        .where((t) => t.name.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Future<DetailedThingModel> getThingDetails({required String id}) async {
    return await _repository.getThingDetails(id: id);
  }

  void select(ThingModel thing) {
    selectedId = thing.id;
    notifyListeners();
  }

  void clearSelection() {
    selectedId = null;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _repository.refresh();
    notifyListeners();
  }
}
