import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/details_card/details_card.dart';

import '../../../models/item_model.dart';
import '../../../../common/widgets/details_card/card_header.dart';

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
    return DetailsCard(
      header: CardHeader(
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
          const SizedBox(height: 8),
        ],
      ),
      showDivider: items.isNotEmpty,
      body: items.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    leading: getIcon(item),
                    title: Text('#${item.number}'),
                    trailing: Text(item.brand ?? 'Generic'),
                  );
                },
                separatorBuilder: (c, i) => const Divider(),
              ),
            )
          : null,
    );
  }

  Widget getIcon(ItemModel item) {
    if (item.hidden) {
      return hiddenIcon;
    }

    return item.available ? checkedInIcon : checkedOutIcon;
  }
}

const checkedInIcon = Tooltip(
  message: 'Available',
  child: Icon(Icons.circle, color: Colors.green, size: 16),
);

const checkedOutIcon = Tooltip(
  message: 'Unavailable',
  child: Icon(Icons.circle, color: Colors.amber, size: 16),
);

const hiddenIcon = Tooltip(
  message: 'Hidden',
  child: Icon(Icons.circle, color: Colors.red, size: 16),
);
