import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/add_inventory_dialog.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import 'details_card_header.dart';

class InventoryDetails extends StatelessWidget {
  const InventoryDetails({
    super.key,
    required this.details,
    this.onAddItems,
  });

  final DetailedThingModel details;

  final void Function(
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
          controller: TextEditingController(text: details.name),
          readOnly: true,
          decoration: inputDecoration.copyWith(
            icon: const Icon(Icons.build),
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: details.spanishName),
          readOnly: true,
          enabled: details.spanishName != null,
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
                        Text('Available: ${details.available}'),
                        const SizedBox(width: 16),
                        Text('Total: ${details.stock}'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (details.items.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: details.items.length,
                    itemBuilder: (context, index) {
                      final item = details.items[index];
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
