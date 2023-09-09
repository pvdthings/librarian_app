import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/image.model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:librarian_app/src/features/inventory/data/item.model.dart';

class InventoryDetailsViewModel extends ChangeNotifier {
  InventoryDetailsViewModel({
    required this.inventory,
    required this.thingId,
    required this.name,
    required this.spanishName,
    required this.hidden,
    required this.image,
    required this.items,
    required this.availableItems,
  });

  final InventoryViewModel inventory;

  late final nameController = TextEditingController(text: name);
  late final spanishNameController = TextEditingController(text: spanishName);
  late final hiddenNotifier = ValueNotifier(hidden);
  late final imageNotifier = ValueNotifier(image);

  final String thingId;
  final String name;
  final String? spanishName;
  final bool hidden;
  final ImageModel? image;
  final List<ItemModel> items;
  final int availableItems;

  bool get hasUnsavedChanges =>
      nameController.text != name ||
      spanishNameController.text != (spanishName ?? '') ||
      hiddenNotifier.value != hidden ||
      imageNotifier.value != image;

  void announceChanges() => notifyListeners();

  Future<void> save() async {
    await inventory.updateThing(
      thingId: thingId,
      name: nameController.text,
      spanishName: spanishNameController.text,
      hidden: hiddenNotifier.value,
    );
  }

  Future<void> discardChanges() async {
    nameController.value = TextEditingValue(text: name);
    spanishNameController.value = spanishName != null
        ? TextEditingValue(text: spanishName!)
        : TextEditingValue.empty;
    hiddenNotifier.value = hidden;
    imageNotifier.value = image;
    notifyListeners();
  }

  Future<void> addItems(
    String? brand,
    String? description,
    double? estimatedValue,
    int quantity,
  ) async {
    await inventory.createItems(
      thingId: thingId,
      brand: brand,
      description: description,
      estimatedValue: estimatedValue,
      quantity: quantity,
    );
  }
}
