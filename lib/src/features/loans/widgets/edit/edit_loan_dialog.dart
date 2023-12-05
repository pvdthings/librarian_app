import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/filled_progress_button.dart';

class EditLoanDialog extends StatefulWidget {
  const EditLoanDialog({
    super.key,
    required this.dueDate,
    required this.isOverdue,
    required this.onSavePressed,
  });

  final DateTime dueDate;
  final bool isOverdue;
  final void Function(DateTime newDueDate) onSavePressed;

  @override
  State<EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<EditLoanDialog> {
  late DateTime dueDate = widget.dueDate;

  bool _hasUnsavedChanges() => dueDate != widget.dueDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledProgressButton(
          onPressed: _hasUnsavedChanges()
              ? () {
                  widget.onSavePressed(dueDate);
                  Navigator.of(context).pop(true);
                }
              : null,
          child: const Text('Save'),
        ),
      ],
      icon: const Icon(Icons.edit),
      title: const Text('Edit Loan'),
      content: TextField(
        controller: TextEditingController(
          text: '${dueDate.month}/${dueDate.day}',
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: dueDate,
            firstDate: widget.dueDate,
            lastDate: widget.dueDate.add(const Duration(days: 14)),
          ).then((value) {
            if (value == null) return;
            setState(() => dueDate = value);
          });
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_month_rounded),
          iconColor: widget.isOverdue ? Colors.orange : null,
          labelText: 'Due Back',
          border: const OutlineInputBorder(),
          constraints: const BoxConstraints(maxWidth: 200),
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
