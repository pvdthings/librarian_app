import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/add_inventory_dialog.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/data/inventory_details.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/items_card.widget.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({super.key, required this.details});

  final InventoryDetailsViewModel details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: details.nameController,
          decoration: inputDecoration.copyWith(
            icon: const Icon(Icons.build),
            labelText: 'Name',
          ),
          onChanged: (_) => details.announceChanges(),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: details.spanishNameController,
          decoration: inputDecoration.copyWith(
            icon: const Icon(Icons.build),
            labelText: 'Name (Spanish)',
          ),
          onChanged: (_) => details.announceChanges(),
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Hidden'),
          value: details.hiddenNotifier.value,
          onChanged: (bool? value) {
            details.hiddenNotifier.value = value ?? false;
            details.announceChanges();
          },
          controlAffinity: ListTileControlAffinity.leading,
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
