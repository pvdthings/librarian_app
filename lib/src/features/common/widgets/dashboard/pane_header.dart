import 'package:flutter/material.dart';

class PaneHeader extends StatelessWidget {
  const PaneHeader({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
      child: SizedBox(
        height: 48,
        child: Center(child: child),
      ),
    );
  }
}
