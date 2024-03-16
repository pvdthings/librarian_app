import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details_controller.dart';
import 'package:librarian_app/src/widgets/filled_progress_button.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_item_details_providers.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/items_card/item_details.dart';

class ItemDetailsDialog extends ConsumerStatefulWidget {
  const ItemDetailsDialog({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  ConsumerState<ItemDetailsDialog> createState() => _ItemDetailsDialogState();
}

class _ItemDetailsDialogState extends ConsumerState<ItemDetailsDialog> {
  late final _controller = ItemDetailsController(item: widget.item);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      actions: [
        OutlinedButton(
          onPressed: () {
            ref.read(itemDetailsEditorProvider).discardChanges();
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ListenableBuilder(
          listenable: _controller,
          builder: (_, __) {
            return _SaveButton(
              itemId: widget.item.id,
              onPressed: _controller.saveChanges,
            );
          },
        ),
      ],
      clipBehavior: Clip.antiAlias,
      title: Text(
        '#${widget.item.number} ${widget.item.name}',
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Container(
        constraints: const BoxConstraints(minWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ItemDetails(
                controller: _controller,
                item: widget.item,
                hiddenLocked: widget.hiddenLocked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton({
    required this.itemId,
    this.onPressed,
  });

  final String itemId;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledProgressButton(
      onPressed: onPressed,
      child: const Text('Save'),
    );
  }
}
