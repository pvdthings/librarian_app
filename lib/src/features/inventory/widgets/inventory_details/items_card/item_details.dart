import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/checkbox_field.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.widget.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/inventory/providers/edited_item_details_providers.dart';
import 'package:librarian_app/src/utils/format.dart';

class ItemDetails extends ConsumerWidget {
  const ItemDetails({
    super.key,
    required this.item,
    required this.hiddenLocked,
  });

  final ItemModel item;
  final bool hiddenLocked;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Builder(
          builder: (context) {
            final checkbox = CheckboxField(
              title: 'Hidden',
              value: item.hidden,
              onChanged: hiddenLocked
                  ? null
                  : (value) {
                      ref.read(hiddenProvider.notifier).state = value;
                    },
            );

            if (!hiddenLocked) {
              return checkbox;
            }

            return Tooltip(
              message: 'Unable to unhide because the thing is hidden.',
              child: checkbox,
            );
          },
        ),
        const SizedBox(height: 24),
        TextFormField(
          controller: TextEditingController(text: item.brand),
          decoration: inputDecoration.copyWith(
            labelText: 'Brand',
            hintText: 'Generic',
          ),
          onChanged: (value) {
            ref.read(brandProvider.notifier).state = value;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: TextEditingController(text: item.description),
          decoration: inputDecoration.copyWith(labelText: 'Description'),
          onChanged: (value) {
            ref.read(descriptionProvider.notifier).state = value;
          },
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
          onChanged: (value) {
            ref.read(estimatedValueProvider.notifier).state =
                double.tryParse(value);
          },
          validator: (value) {
            final doubleValue = double.tryParse(value ?? '');
            return doubleValue != null ? null : 'Must be a valid dollar amount';
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField(
          decoration: inputDecoration.copyWith(labelText: 'Condition'),
          items: const [
            DropdownMenuItem(value: 'Damaged', child: Text('Damaged')),
          ],
          onChanged: (value) {
            ref.read(conditionProvider.notifier).state = value;
          },
          value: item.condition,
        ),
      ],
    );
  }
}
