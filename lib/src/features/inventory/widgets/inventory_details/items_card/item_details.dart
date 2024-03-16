import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details_controller.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/thing_image_card/thing_image_card.dart';
import 'package:librarian_app/src/widgets/fields/checkbox_field.dart';
import 'package:librarian_app/src/widgets/input_decoration.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';

class ItemDetails extends ConsumerWidget {
  const ItemDetails({
    super.key,
    required this.controller,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemDetailsController controller;
  final ItemModel item;
  final bool hiddenLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return ThingImageCard(
              imageUrl: item.imageUrls.firstOrNull,
              imageBytes: controller.uploadedImageBytes,
              height: 240,
              onRemove: controller.removeImage,
              onReplace: controller.replaceImage,
              useNewDesign: true,
            );
          },
        ),
        const SizedBox(height: 32),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final checkbox = CheckboxField(
              title: 'Hide in Catalog',
              value: controller.hiddenNotifier.value,
              onChanged: hiddenLocked
                  ? null
                  : (value) {
                      controller.hiddenNotifier.value = value ?? false;
                    },
            );

            if (!hiddenLocked) {
              return checkbox;
            }

            return Tooltip(
              message: 'Unable to unhide because the thing is hidden.',
              child: checkbox,
            );
          },
        ),
        const SizedBox(height: 32),
        TextFormField(
          controller: controller.brandController,
          decoration: inputDecoration.copyWith(
            labelText: 'Brand',
            hintText: 'Generic',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.descriptionController,
          decoration: inputDecoration.copyWith(labelText: 'Description'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller.estimatedValueController,
          decoration: inputDecoration.copyWith(
            labelText: 'Estimated Value (\$)',
            prefixText: '\$ ',
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return DropdownButtonFormField(
              decoration: inputDecoration.copyWith(labelText: 'Condition'),
              items: const [
                DropdownMenuItem(
                  value: null,
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: 'Like New',
                  child: Text('Like New'),
                ),
                DropdownMenuItem(
                  value: 'Lightly Used',
                  child: Text('Lightly Used'),
                ),
                DropdownMenuItem(
                  value: 'Heavily Used',
                  child: Text('Heavily Used'),
                ),
                DropdownMenuItem(
                  value: 'Damaged',
                  child: Text('Damaged'),
                ),
              ],
              onChanged: (value) {
                controller.conditionNotifier.value = value;
              },
              value: controller.conditionNotifier.value,
            );
          },
        ),
      ],
    );
  }
}
