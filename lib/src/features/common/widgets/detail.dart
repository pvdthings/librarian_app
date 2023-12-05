import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.label,
    required this.value,
    this.prefixIcon,
  });

  final String label;
  final String value;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      value,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.black38,
          ),
          child: prefixIcon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    prefixIcon!,
                    const SizedBox(width: 8),
                    text,
                  ],
                )
              : text,
        ),
      ],
    );
  }
}
