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
    this.useListTile = false,
  });

  final String label;
  final String? value;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? minWidth;
  final String? placeholderText;
  final bool useListTile;

  @override
  Widget build(BuildContext context) {
    if (useListTile) {
      return Container(
        constraints: const BoxConstraints(
          minWidth: 200,
          maxWidth: 500,
        ),
        child: ListTile(
          leading: prefixIcon,
          trailing: suffixIcon,
          title: Text(label),
          titleTextStyle: Theme.of(context).textTheme.labelLarge,
          subtitle: Text(value ?? placeholderText ?? ''),
          subtitleTextStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 20, color: value == null ? Colors.white54 : null),
        ),
      );
    }

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
        prefixIcon != null
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
      ],
    );
  }
}
