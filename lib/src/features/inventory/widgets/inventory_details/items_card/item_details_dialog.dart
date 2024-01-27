import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_item_details_providers.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details.dart';

class ItemDetailsDialog extends ConsumerWidget {
  const ItemDetailsDialog({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      actions: [
        OutlinedButton(
          onPressed: () {
            ref.read(itemDetailsEditorProvider).discardChanges();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        _SaveButton(itemId: item.id),
      ],
      clipBehavior: Clip.antiAlias,
      title: Text(
        '#${item.number} ${item.name}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Container(
        constraints: const BoxConstraints(minWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ItemDetails(item: item, hiddenLocked: hiddenLocked),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledProgressButton(
      onPressed: ref.watch(unsavedChangesProvider)
          ? () {
              ref
                  .read(itemDetailsEditorProvider)
                  .save(itemId)
                  .then((_) => Navigator.of(context).pop());
            }
          : null,
      child: const Text('Save'),
    );
  }
}
