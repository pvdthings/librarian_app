import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/checkbox_field.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/utils/format.dart';

class ItemDetailsDialog extends ConsumerWidget {
  const ItemDetailsDialog({super.key, required this.number});

  final int number;

  // Enable Save when changes have been made

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Future<ItemModel?> itemFuture =
        ref.read(thingsRepositoryProvider.notifier).getItem(number: number);

    return AlertDialog(
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        const FilledButton(
          onPressed: null,
          child: Text('Save'),
        ),
      ],
      clipBehavior: Clip.antiAlias,
      title: FutureBuilder(
        future: itemFuture,
        builder: (context, snapshot) {
          final ItemModel? item = snapshot.data;
          final String? name = item?.name;
          return Text(
            name != null ? '#${item!.number} $name' : '',
            style: Theme.of(context).textTheme.titleLarge,
          );
        },
      ),
      content: Container(
        constraints: const BoxConstraints(minWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: itemFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final ItemModel item = snapshot.data!;

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: ItemDetails(item: item),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ItemDetails extends StatelessWidget {
  const ItemDetails({super.key, required this.item});

  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        CheckboxField(
          title: 'Hidden',
          value: item.hidden,
          onChanged: (value) {},
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: TextEditingController(text: item.brand),
          decoration: inputDecoration.copyWith(
            labelText: 'Brand',
            hintText: 'Generic',
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: TextEditingController(text: item.description),
          decoration: inputDecoration.copyWith(labelText: 'Description'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller:
              TextEditingController(text: formatNumber(item.estimatedValue)),
          decoration: inputDecoration.copyWith(
            labelText: 'Estimated Value (\$)',
            prefixText: '\$ ',
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField(
          decoration: inputDecoration.copyWith(labelText: 'Condition'),
          items: const [
            DropdownMenuItem(value: 'Damaged', child: Text('Damaged')),
          ],
          onChanged: null,
          value: item.condition,
        ),
      ],
    );
  }
}
