import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';

import '../../../../models/thing_model.dart';

class CreateItemsController extends ChangeNotifier {
  CreateItemsController({
    required this.thing,
    this.repository,
    this.onSave,
    this.onSaveComplete,
  });

  final ThingModel thing;
  final InventoryRepository? repository;
  final Function()? onSave;
  final Function()? onSaveComplete;

  late final hiddenNotifier = ValueNotifier<bool>(false)
    ..addListener(notifyListeners);

  late final brandController = TextEditingController()
    ..addListener(notifyListeners);

  late final descriptionController = TextEditingController()
    ..addListener(notifyListeners);

  late final estimatedValueController = TextEditingController()
    ..addListener(notifyListeners);

  late final conditionNotifier = ValueNotifier<String?>(null)
    ..addListener(notifyListeners);

  late final quantityController = TextEditingController(text: '1')
    ..addListener(notifyListeners);

  bool isLoading = false;

  Uint8List? _uploadedImageBytes;
  String? _uploadedImageType;

  Uint8List? get uploadedImageBytes => _uploadedImageBytes;

  void _replaceImage() async {
    FilePickerResult? result =
        await FilePickerWeb.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _uploadedImageBytes = result.files.single.bytes;
      _uploadedImageType = result.files.single.extension;
      notifyListeners();
    }
  }

  void Function()? get replaceImage {
    if (isLoading) {
      return null;
    }

    return _replaceImage;
  }

  void _removeImage() {
    _uploadedImageBytes = null;
    _uploadedImageType = null;
    notifyListeners();
  }

  void Function()? get removeImage {
    if (_uploadedImageBytes == null) {
      return null;
    }

    return _removeImage;
  }

  void _saveChanges() async {
    onSave?.call();

    final quantity = int.parse(quantityController.text);
    final estimatedValue = double.tryParse(estimatedValueController.text);

    await repository?.createItems(
        thingId: thing.id,
        quantity: quantity,
        brand: brandController.text,
        condition: conditionNotifier.value,
        description: descriptionController.text,
        estimatedValue: estimatedValue,
        hidden: hiddenNotifier.value,
        image: _uploadedImageBytes != null
            ? UpdatedImageModel(
                type: _uploadedImageType,
                bytes: _uploadedImageBytes,
              )
            : null);

    onSaveComplete?.call();
  }

  UpdatedImageModel? createUpdatedImageModel() {
    if (_uploadedImageBytes != null) {
      return UpdatedImageModel(
        type: _uploadedImageType,
        bytes: _uploadedImageBytes,
      );
    }

    return null;
  }

  void Function()? get saveChanges {
    if (isLoading || repository == null) {
      return null;
    }

    return _saveChanges;
  }
}
