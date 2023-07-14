import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/filled_progress_button.dart';

class CheckinDialog extends StatefulWidget {
  final int thingNumber;
  final Future<void> Function()? onCheckin;
  final void Function()? onPostCheckin;

  const CheckinDialog({
    super.key,
    required this.thingNumber,
    this.onCheckin,
    this.onPostCheckin,
  });

  @override
  State<CheckinDialog> createState() => _CheckinDialogState();
}

class _CheckinDialogState extends State<CheckinDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thing #${widget.thingNumber}"),
      content: Text(
          "Are you sure you want to check Thing #${widget.thingNumber} back in?"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledProgressButton(
          child: const Text('Yes'),
          onPressed: () {
            Future.delayed(const Duration(seconds: 2), () async {
              await widget.onCheckin?.call();
            }).whenComplete(() {
              Navigator.of(context).pop();
              widget.onPostCheckin?.call();
            });
          },
        ),
      ],
    );
  }
}
