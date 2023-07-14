import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/filled_progress_button.dart';

class CheckinDialog extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Thing #$thingNumber"),
      content:
          Text("Are you sure you want to check Thing #$thingNumber back in?"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        FilledProgressButton(
          child: const Text('Yes'),
          onPressed: () {
            Future.delayed(const Duration(seconds: 2), () async {
              await onCheckin?.call();
            }).whenComplete(() {
              Navigator.of(context).pop();
              onPostCheckin?.call();
            });
          },
        ),
      ],
    );
  }
}
