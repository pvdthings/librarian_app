import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/image.model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:librarian_app/src/features/inventory/data/item.model.dart';
import 'package:librarian_app/src/features/inventory/data/updated_image_model.dart';

class InventoryDetailsViewModel extends ChangeNotifier {
  InventoryDetailsViewModel({
    required this.inventory,
    required this.thingId,
    required this.name,
    required this.spanishName,
    required this.hidden,
    required this.images,
    required this.items,
    required this.availableItems,
  });

  final InventoryViewModel inventory;

  late final nameController = TextEditingController(text: name);
  late final spanishNameController = TextEditingController(text: spanishName);
  late final hiddenNotifier = ValueNotifier(hidden);
  late final imageNotifier = ValueNotifier(images.firstOrNull);
  late final imageUploadNotifier = ValueNotifier<UpdatedImageModel?>(null);

  final String thingId;
  final String name;
  final String? spanishName;
  final bool hidden;
  final List<ImageModel> images;
  final List<ItemModel> items;
  final int availableItems;

  bool get hasUnsavedChanges =>
      nameController.text != name ||
      spanishNameController.text != (spanishName ?? '') ||
      hiddenNotifier.value != hidden ||
      imageNotifier.value != images.firstOrNull ||
      imageUploadNotifier.value != null;

  void announceChanges() => notifyListeners();

  Future<void> save() async {
    await inventory.updateThing(
      thingId: thingId,
      name: nameController.text,
      spanishName: spanishNameController.text,
      hidden: hiddenNotifier.value,
      image: imageUploadNotifier.value,
    );
  }

  Future<void> discardChanges() async {
    nameController.value = TextEditingValue(text: name);
    spanishNameController.value = spanishName != null
        ? TextEditingValue(text: spanishName!)
        : TextEditingValue.empty;
    hiddenNotifier.value = hidden;
    imageNotifier.value = images.firstOrNull;
    imageUploadNotifier.value = null;
    notifyListeners();
  }

  void removeImage() {
    imageNotifier.value = null;
    imageUploadNotifier.value =
        const UpdatedImageModel(type: null, bytes: null);
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
