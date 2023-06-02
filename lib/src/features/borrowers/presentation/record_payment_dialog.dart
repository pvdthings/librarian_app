import 'package:flutter/material.dart';

class RecordPaymentDialog extends StatelessWidget {
  final _cashController = TextEditingController();

  final void Function(double cash) onConfirmPayment;

  RecordPaymentDialog({
    super.key,
    required this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
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
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) {
                return _ConfirmDialog(
                  content: Text(
                      'Are you sure you want to record a \$${_cashController.text} cash payment?'),
                  onConfirm: () =>
                      onConfirmPayment(double.parse(_cashController.text)),
                  onCancel: () => Navigator.of(context).pop(),
                );
              },
            );
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
