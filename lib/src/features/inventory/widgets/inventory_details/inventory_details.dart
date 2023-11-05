import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/checkbox_field.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/models/updated_image_model.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_thing_details_providers.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/add_inventory_dialog.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/categories_card.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details_dialog.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/items_card.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/thing_image_card/thing_image_card.dart';

class InventoryDetails extends ConsumerWidget {
  const InventoryDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsFuture = ref.watch(thingDetailsProvider);

    return FutureBuilder(
      future: detailsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final details = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 16,
              runSpacing: 32,
              children: [
                ThingImageCard(
                  imageUrl: ref.watch(imageUploadProvider) != null
                      ? null
                      : details.images.firstOrNull?.url,
                  imageBytes: ref.watch(imageUploadProvider)?.bytes,
                  onRemove: () {
                    ref.read(imageUploadProvider.notifier).state =
                        const UpdatedImageModel(type: null, bytes: null);
                  },
                  onReplace: () async {
                    FilePickerResult? result = await FilePickerWeb.platform
                        .pickFiles(type: FileType.image);
                    if (result != null) {
                      ref.read(imageUploadProvider.notifier).state =
                          UpdatedImageModel(
                        type: result.files.single.extension,
                        bytes: result.files.single.bytes,
                      );
                    }
                  },
                ),
                Column(
                  children: [
                    TextField(
                      controller: TextEditingController(text: details.name),
                      decoration: inputDecoration.copyWith(labelText: 'Name'),
                      onChanged: (value) =>
                          ref.read(nameProvider.notifier).state = value,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller:
                          TextEditingController(text: details.spanishName),
                      decoration:
                          inputDecoration.copyWith(labelText: 'Name (Spanish)'),
                      onChanged: (value) =>
                          ref.read(spanishNameProvider.notifier).state = value,
                    ),
                  ],
                ),
                CheckboxField(
                  title: 'Hidden',
                  value: ref.watch(hiddenProvider) ?? details.hidden,
                  onChanged: (bool? value) {
                    ref.read(hiddenProvider.notifier).state = value ?? false;
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            const CategoriesCard(),
            const SizedBox(height: 32),
            ItemsCard(
              items: details.items,
              availableItemsCount: details.available,
              onTap: (int number) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ItemDetailsDialog(number: number);
                  },
                );
              },
              onAddItemsPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddInventoryDialog(
                    onCreate: (String? brand, String? description,
                        double? estimatedValue, int quantity) async {
                      await ref
                          .read(thingsRepositoryProvider.notifier)
                          .createItems(
                              thingId: ref.read(selectedThingProvider)!.id,
                              brand: brand,
                              description: description,
                              estimatedValue: estimatedValue,
                              quantity: quantity);
                    },
                  ),
                );
              },
              onToggleHidden: details.hidden
                  ? null
                  : (id, value) async {
                      await ref
                          .read(thingsRepositoryProvider.notifier)
                          .updateItem(id, hidden: value);
                    },
            ),
          ],
        );
      },
    );
  }
}
