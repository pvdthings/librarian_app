import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.black38,
          ),
          child: Text(
            value,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
