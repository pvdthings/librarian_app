import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_repository.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';
import 'package:librarian_app/src/utils/format.dart';

import '../../../../models/item_model.dart';

class ItemDetailsController extends ChangeNotifier {
  ItemDetailsController({
    this.item,
    this.repository,
    this.onSave,
    this.onSaveComplete,
  }) {
    _loadItemDetails();
  }

  ItemModel? item;
  final InventoryRepository? repository;
  final Function()? onSave;
  final Function()? onSaveComplete;

  late ValueNotifier<bool> hiddenNotifier = ValueNotifier(false)
    ..addListener(notifyListeners);
  late TextEditingController brandController = TextEditingController()
    ..addListener(notifyListeners);
  late TextEditingController descriptionController = TextEditingController()
    ..addListener(notifyListeners);
  late TextEditingController estimatedValueController = TextEditingController()
    ..addListener(notifyListeners);
  late ValueNotifier<String?> conditionNotifier = ValueNotifier(null)
    ..addListener(notifyListeners);

  bool isLoading = false;

  Future<void> _loadItemDetails() async {
    isLoading = true;
    notifyListeners();

    item = await repository?.getItem(number: item!.number);

    hiddenNotifier.value = (item?.hidden ?? false);

    if (item?.brand != null) {
      brandController.text = item!.brand!;
    }

    if (item?.description != null) {
      descriptionController.text = item!.description!;
    }

    final estimatedValue = formatNumber(item?.estimatedValue);
    if (estimatedValue != null) {
      estimatedValueController.text = estimatedValue;
    }

    if (item?.condition != null) {
      conditionNotifier.value = item!.condition!;
    }

    isLoading = false;
    notifyListeners();
  }

  bool _removeExistingImage = false;

  Uint8List? _uploadedImageBytes;
  String? _uploadedImageType;

  Uint8List? get uploadedImageBytes => _uploadedImageBytes;

  String? get existingImageUrl =>
      _removeExistingImage ? null : item?.imageUrls.firstOrNull;

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
    if (existingImageUrl != null) {
      _removeExistingImage = true;
    }

    _uploadedImageBytes = null;
    _uploadedImageType = null;
    notifyListeners();
  }

  void Function()? get removeImage {
    if (existingImageUrl == null && _uploadedImageBytes == null) {
      return null;
    }

    return _removeImage;
  }

  void _saveChanges() async {
    onSave?.call();

    final estimatedValue = double.tryParse(estimatedValueController.text);

    await repository?.updateItem(item!.id,
        brand: brandController.text,
        description: descriptionController.text,
        condition: conditionNotifier.value,
        estimatedValue: estimatedValue,
        hidden: hiddenNotifier.value,
        image: createUpdatedImageModel());

    _discardChanges();
    await _loadItemDetails();

    onSaveComplete?.call();
  }

  UpdatedImageModel? createUpdatedImageModel() {
    if (_removeExistingImage) {
      return const UpdatedImageModel(type: null, bytes: null);
    }

    if (_uploadedImageBytes != null) {
      return UpdatedImageModel(
        type: _uploadedImageType,
        bytes: _uploadedImageBytes,
      );
    }

    return null;
  }

  void _discardChanges() {
    _uploadedImageBytes = null;
    _uploadedImageType = null;
    _removeExistingImage = false;
  }

  void Function()? get saveChanges {
    if (isLoading || item == null || repository == null) {
      return null;
    }

    if (hasUnsavedChanges) {
      return _saveChanges;
    }

    return null;
  }

  bool get hasUnsavedChanges {
    return _uploadedImageBytes != null ||
        hiddenNotifier.value != (item?.hidden ?? false) ||
        brandController.text != (item?.brand ?? '') ||
        descriptionController.text != (item?.description ?? '') ||
        estimatedValueController.text !=
            (formatNumber(item?.estimatedValue) ?? '') ||
        conditionNotifier.value != item?.condition ||
        _removeExistingImage;
  }
}
