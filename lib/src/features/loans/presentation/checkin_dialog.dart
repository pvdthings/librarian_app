import 'package:flutter/material.dart';

class CheckinDialog extends StatelessWidget {
  final int thingNumber;
  final Function()? onCheckin;
  final Function()? onPostCheckin;

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
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("Yes"),
          onPressed: () async {
            await onCheckin?.call();

            Future.delayed(
              Duration.zero,
              () {
                Navigator.of(context).pop();
                onPostCheckin?.call();
              },
            );
          },
        ),
      ],
    );
  }
}
