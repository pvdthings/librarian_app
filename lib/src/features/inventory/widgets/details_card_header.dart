import 'package:flutter/material.dart';

class DetailsCardHeader extends StatelessWidget {
  const DetailsCardHeader({
    super.key,
    required this.title,
    this.trailing,
    this.children,
  });

  final String title;
  final Widget? trailing;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (trailing != null) trailing!
            ],
          ),
          const SizedBox(height: 8),
          if (children != null) ...children!
        ],
      ),
    );
  }
}
