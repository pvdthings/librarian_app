import 'package:flutter/material.dart';

class CheckboxField extends StatelessWidget {
  final String title;
  final bool value;
  final void Function(bool? value) onChanged;

  const CheckboxField({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        const SizedBox(width: 8),
        TapRegion(
          onTapInside: (_) => onChanged(!value),
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
