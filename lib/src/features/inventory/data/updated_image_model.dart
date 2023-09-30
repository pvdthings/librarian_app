import 'dart:typed_data';

class UpdatedImageModel {
  final String? type;
  final Uint8List? bytes;
  final String? url;

  const UpdatedImageModel({
    this.type,
    this.bytes,
    this.url,
  });
}
