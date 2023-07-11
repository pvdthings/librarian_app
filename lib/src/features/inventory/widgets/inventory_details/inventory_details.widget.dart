import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/add_inventory_dialog.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/items_card.widget.dart';

import '../../data/item.model.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({
    super.key,
    required this.nameController,
    required this.spanishNameController,
    required this.items,
    required this.availableItems,
    this.onAddItems,
    this.readOnly = true,
  });

  final TextEditingController nameController;
  final TextEditingController spanishNameController;
  final List<ItemModel> items;
  final int availableItems;
  final bool readOnly;

  final Future<void> Function(
    String? brand,
    String? description,
    double? estimatedValue,
    int quantity,
  )? onAddItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          readOnly: readOnly,
          decoration: inputDecoration.copyWith(
            icon: const Icon(Icons.build),
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: spanishNameController,
          readOnly: readOnly,
          enabled: spanishNameController.text.isNotEmpty || !readOnly,
          decoration: inputDecoration.copyWith(
            icon: const Icon(Icons.build),
            labelText: 'Name (Spanish)',
          ),
        ),
        const SizedBox(height: 32),
        ItemsCard(
          items: items,
          availableItemsCount: availableItems,
          onAddItemsPressed: () {
            showDialog(
              context: context,
              builder: (context) => AddInventoryDialog(
                onCreate: onAddItems,
              ),
            );
          },
        ),
      ],
    );
  }
}
