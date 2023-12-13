import 'package:flutter/material.dart';

PopupMenuEntry createMenuItem({
  required void Function() onTap,
  required String text,
  required BuildContext context,
}) {
  return PopupMenuItem(
    onTap: onTap,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const Icon(Icons.add),
      ],
    ),
  );
}
