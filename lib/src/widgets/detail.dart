import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.label,
    required this.value,
    this.prefixIcon,
    this.suffixIcon,
    this.minWidth,
    this.placeholderText,
  });

  final String label;
  final String? value;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? minWidth;
  final String? placeholderText;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      value ?? placeholderText ?? '',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(fontSize: 20, color: value == null ? Colors.white54 : null),
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
          constraints:
              minWidth != null ? const BoxConstraints(minWidth: 300) : null,
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
                    if (suffixIcon != null) ...[
                      const SizedBox(width: 8),
                      suffixIcon!,
                    ],
                  ],
                )
              : text,
        ),
      ],
    );
  }
}
