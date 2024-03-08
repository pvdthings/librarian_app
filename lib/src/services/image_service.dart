import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class ImageService {
  Future<ImageUploadResult> uploadImage({
    required Uint8List bytes,
    required String type,
  }) async {
    final guid = const Uuid().v4();
    final path = '$guid.$type';

    await Supabase.instance.client.storage
        .from('librarian_images')
        .uploadBinary(path, bytes);

    final String url = Supabase.instance.client.storage
        .from('librarian_images')
        .getPublicUrl(path);

    return ImageUploadResult(url: url);
  }

  String getPublicUrl(String bucket, String path) {
    return Supabase.instance.client.storage.from(bucket).getPublicUrl(path);
  }
}

class ImageUploadResult {
  final String url;

  const ImageUploadResult({required this.url});
}
