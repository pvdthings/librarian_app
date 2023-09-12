import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/checkbox_field.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/data/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/add_inventory_dialog.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/data/inventory_details.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/items_card.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/thing_image_card/thing_image_card.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({super.key, required this.details});

  final InventoryDetailsViewModel details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 32,
          children: [
            ThingImageCard(
              imageUrl: details.imageNotifier.value != null
                  ? details.imageNotifier.value!.url
                  : null,
              imageBytes: details.imageUploadNotifier.value?.bytes,
              onRemove: () {
                details.imageNotifier.value = null;
                details.announceChanges();
              },
              onReplace: () async {
                FilePickerResult? result = await FilePickerWeb.platform
                    .pickFiles(type: FileType.image);
                if (result != null) {
                  details.imageUploadNotifier.value = UpdatedImageModel(
                    type: result.files.single.extension,
                    bytes: result.files.single.bytes,
                  );

                  details.announceChanges();
                }
              },
            ),
            Column(
              children: [
                TextField(
                  controller: details.nameController,
                  decoration: inputDecoration.copyWith(labelText: 'Name'),
                  onChanged: (_) => details.announceChanges(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: details.spanishNameController,
                  decoration:
                      inputDecoration.copyWith(labelText: 'Name (Spanish)'),
                  onChanged: (_) => details.announceChanges(),
                ),
              ],
            ),
            CheckboxField(
              title: 'Hidden',
              value: details.hiddenNotifier.value,
              onChanged: (bool? value) {
                details.hiddenNotifier.value = value ?? false;
                details.announceChanges();
              },
            ),
          ],
        ),
        const SizedBox(height: 32),
        ItemsCard(
          items: details.items,
          availableItemsCount: details.availableItems,
          onAddItemsPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddInventoryDialog(
                onCreate: details.addItems,
              ),
            );
          },
        ),
      ],
    );
  }
}
