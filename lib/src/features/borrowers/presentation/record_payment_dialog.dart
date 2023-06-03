import 'package:flutter/material.dart';

class RecordPaymentDialog extends StatefulWidget {
  final void Function(double cash) onConfirmPayment;

  const RecordPaymentDialog({
    super.key,
    required this.onConfirmPayment,
  });

  @override
  State<RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<RecordPaymentDialog> {
  final _cashController = TextEditingController();

  bool _confirm = false;

  @override
  Widget build(BuildContext context) {
    if (_confirm) {
      return _ConfirmDialog(
        content: Text(
            'Are you sure you want to record a \$${_cashController.text} cash payment?'),
        onConfirm: () {
          widget.onConfirmPayment(double.parse(_cashController.text));
          Navigator.pop(context, true);
        },
        onCancel: () => Navigator.pop(context, false),
      );
    }

    return AlertDialog(
      title: const Text('Record Cash Payment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _cashController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.currency_exchange_rounded),
              labelText: 'Cash',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() => _confirm = true);
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class _ConfirmDialog extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onCancel;
  final Widget? content;

  const _ConfirmDialog({
    required this.onConfirm,
    required this.onCancel,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: [
        FilledButton(
          onPressed: onCancel,
          child: const Text('NO'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('YES'),
        ),
      ],
    );
  }
}
