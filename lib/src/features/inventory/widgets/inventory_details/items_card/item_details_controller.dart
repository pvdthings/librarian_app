import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:librarian_app/src/utils/format.dart';

import '../../../models/item_model.dart';

class ItemDetailsController extends ChangeNotifier {
  ItemDetailsController({this.item});

  final ItemModel? item;

  late final hiddenNotifier = ValueNotifier(item?.hidden ?? false)
    ..addListener(notifyListeners);

  late final brandController = TextEditingController(text: item?.brand)
    ..addListener(notifyListeners);

  late final descriptionController =
      TextEditingController(text: item?.description)
        ..addListener(notifyListeners);

  late final estimatedValueController =
      TextEditingController(text: formatNumber(item?.estimatedValue))
        ..addListener(notifyListeners);

  late final conditionNotifier = ValueNotifier(item?.condition)
    ..addListener(notifyListeners);

  Uint8List? _uploadedImageBytes;
  String? _uploadedImageType;

  Uint8List? get uploadedImageBytes => _uploadedImageBytes;

  void replaceImage() async {
    FilePickerResult? result =
        await FilePickerWeb.platform.pickFiles(type: FileType.image);

    if (result != null) {
      _uploadedImageBytes = result.files.single.bytes;
      _uploadedImageType = result.files.single.extension;
      notifyListeners();
    }
  }

  void _removeImage() {
    _uploadedImageBytes = null;
    notifyListeners();
  }

  void Function()? get removeImage {
    if (_uploadedImageBytes == null) {
      return null;
    }

    return _removeImage;
  }

  void _saveChanges() {}

  void Function()? get saveChanges {
    if (_uploadedImageBytes != null ||
        hiddenNotifier.value != (item?.hidden ?? false) ||
        brandController.text != (item?.brand ?? '') ||
        descriptionController.text != (item?.description ?? '') ||
        estimatedValueController.text !=
            (formatNumber(item?.estimatedValue) ?? '') ||
        conditionNotifier.value != item?.condition) {
      return _saveChanges;
    }

    return null;
  }
}
