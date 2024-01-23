import 'package:flutter/material.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({
    super.key,
    required this.title,
    this.message,
  });

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_outline),
      title: Text(title),
      content: message != null ? Text(message!) : null,
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
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Delete'),
        )
      ],
    );
  }
}

Future<bool> showDeleteDialog(
  BuildContext context, {
  String title = 'Delete',
  String? message,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (_) => DeleteDialog(title: title, message: message),
      ) ??
      false;
}
