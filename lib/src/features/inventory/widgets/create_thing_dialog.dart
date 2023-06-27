import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.dart';

class CreateThingDialog extends StatelessWidget {
  CreateThingDialog({super.key, this.onCreate});

  final void Function(String name, String? spanishName)? onCreate;

  final _name = TextEditingController();
  final _spanishName = TextEditingController();

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
                    'New Thing',
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
                controller: _name,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name',
                  icon: const Icon(Icons.build),
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _spanishName,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name (Spanish)',
                  icon: const Icon(Icons.build),
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
                      onCreate?.call(_name.text, _spanishName.text);
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
