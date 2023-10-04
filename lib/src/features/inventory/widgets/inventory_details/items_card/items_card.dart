import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../../models/item_model.dart';
import 'details_card_header.dart';

class ItemsCard extends StatelessWidget {
  const ItemsCard({
    super.key,
    required this.items,
    required this.availableItemsCount,
    required this.onAddItemsPressed,
  });

  final List<ItemModel> items;
  final int availableItemsCount;
  final void Function() onAddItemsPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                onPressed: onAddItemsPressed,
                icon: const Icon(Icons.add),
                label: const Text('Add items'),
              ),
              children: [
                Row(
                  children: [
                    Text('Available: $availableItemsCount'),
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
                    leading: item.available ? checkedInIcon : checkedOutIcon,
                    title: Text('#${item.number}'),
                    trailing: Text(item.brand ?? 'Generic'),
                  );
                },
                separatorBuilder: (c, i) => const Divider(),
              ),
          ],
        ),
      ),
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
