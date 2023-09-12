import 'dart:typed_data';

class UpdatedImageModel {
  final String? type;
  final Uint8List? bytes;

  const UpdatedImageModel({
    required this.type,
    required this.bytes,
  });
}
