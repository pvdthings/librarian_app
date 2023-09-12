import 'dart:typed_data';

import 'package:flutter/material.dart';

class ThingImageCard extends StatelessWidget {
  const ThingImageCard({
    super.key,
    this.imageUrl,
    this.imageBytes,
    required this.onRemove,
    required this.onReplace,
  });

  final String? imageUrl;
  final Uint8List? imageBytes;
  final void Function() onRemove;
  final void Function() onReplace;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 240,
              height: 240,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: imageBytes != null
                  ? Image.memory(
                      imageBytes!,
                      fit: BoxFit.cover,
                    )
                  : imageUrl != null
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : null,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: onReplace,
                  child: const Text('Choose'),
                ),
                TextButton(
                  onPressed: imageUrl != null ? onRemove : null,
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
