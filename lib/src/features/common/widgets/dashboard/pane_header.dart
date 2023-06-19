import 'package:flutter/material.dart';

class PaneHeader extends StatelessWidget {
  const PaneHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).primaryColor.withAlpha(155)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          height: 48,
          child: Center(child: child),
        ),
      ),
    );
  }
}
