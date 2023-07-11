import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/dialogs/add_inventory_dialog.widget.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../data/item.model.dart';
import 'details_card_header.widget.dart';

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
        Card(
          elevation: isMobile(context) ? 1 : 0,
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                DetailsCardHeader(
                  title: 'Inventory',
                  trailing: TextButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddInventoryDialog(
                          onCreate: onAddItems,
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add items'),
                  ),
                  children: [
                    Row(
                      children: [
                        Text('Available: $availableItems'),
                        const SizedBox(width: 16),
                        Text('Total: ${items.length}'),
                      ],
                    ),
                  ],
                ),
                if (items.isNotEmpty) const Divider(),
                if (items.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];

                      return ListTile(
                        leading:
                            item.available ? checkedInIcon : checkedOutIcon,
                        title: Text('#${item.number}'),
                        trailing: Text(item.brand ?? 'Generic'),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

const checkedInIcon = Tooltip(
  message: 'Available',
  child: Icon(Icons.circle, color: Colors.green, size: 16),
);

const checkedOutIcon = Tooltip(
  message: 'Checked out',
  child: Icon(Icons.circle, color: Colors.amber, size: 16),
);
