import 'package:flutter/material.dart';

class ThingListTile extends StatelessWidget {
  final int id;
  final String name;
  final bool available;
  final bool selected;
  final Function()? onTap;

  const ThingListTile({
    super.key,
    required this.id,
    required this.name,
    required this.available,
    required this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: available
          ? const Text(
              "Available",
              style: TextStyle(color: Colors.green),
            )
          : const Text(
              "Checked out",
              style: TextStyle(color: Colors.orange),
            ),
      leading: Text("#$id"),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: Colors.green)
          : null,
      onTap: onTap,
    );
  }
}
