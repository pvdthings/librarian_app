import 'package:flutter/material.dart';

class SaveDialog extends StatelessWidget {
  const SaveDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Save Changes'),
      content: const Text('Are you sure you want to save?'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        )
      ],
    );
  }
}

Future<bool> showSaveDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => const SaveDialog(),
      ) ??
      false;
}
