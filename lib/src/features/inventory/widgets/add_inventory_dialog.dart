import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.dart';

class AddInventoryDialog extends StatelessWidget {
  AddInventoryDialog({super.key, this.onCreate});

  final void Function(
    String? brand,
    String? description,
    double? estimatedValue,
    int quantity,
  )? onCreate;

  final _quantity = TextEditingController(text: '1');
  final _brand = TextEditingController();
  final _estimatedValue = TextEditingController();
  final _description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add Items',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _quantity,
                decoration: inputDecoration.copyWith(
                  labelText: 'Quantity',
                  icon: const Icon(Icons.numbers),
                  constraints: const BoxConstraints(maxWidth: 150),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _brand,
                decoration: inputDecoration.copyWith(
                  labelText: 'Brand',
                  icon: const Icon(Icons.label),
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _estimatedValue,
                decoration: inputDecoration.copyWith(
                  labelText: 'Estimated Value',
                  icon: const Icon(Icons.currency_exchange),
                  prefixText: '\$',
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _description,
                decoration: inputDecoration.copyWith(
                  labelText: 'Description',
                  icon: const Icon(Icons.description),
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: () {
                      onCreate?.call(
                        _brand.text,
                        _description.text,
                        double.tryParse(_estimatedValue.text),
                        int.tryParse(_quantity.text) ?? 1,
                      );
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
