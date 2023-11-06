import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_item_details_providers.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details.dart';

import '../models/item_model.dart';

class ItemDetailsPage extends ConsumerWidget {
  const ItemDetailsPage({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(itemDetailsEditorProvider).discardChanges();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('#${item.number} ${item.name}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ItemDetails(item: item, hiddenLocked: hiddenLocked),
        ),
        floatingActionButton: _FloatingActionSaveButton(itemId: item.id),
      ),
    );
  }
}

class _FloatingActionSaveButton extends ConsumerWidget {
  const _FloatingActionSaveButton({required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Visibility(
      visible: ref.watch(unsavedChangesProvider),
      child: FloatingActionButton(
        onPressed: ref.watch(unsavedChangesProvider)
            ? () {
                ref
                    .read(itemDetailsEditorProvider)
                    .save(itemId)
                    .then((_) => Navigator.of(context).pop());
              }
            : null,
        child: const Icon(Icons.save),
      ),
    );
  }
}
