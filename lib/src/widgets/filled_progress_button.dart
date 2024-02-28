import 'package:flutter/material.dart';
import 'package:librarian_app/src/widgets/circular_progress_icon.dart';

class FilledProgressButton extends StatefulWidget {
  const FilledProgressButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final void Function()? onPressed;

  @override
  State<FilledProgressButton> createState() => _FilledProgressButtonState();
}

class _FilledProgressButtonState extends State<FilledProgressButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return FilledButton.icon(
        onPressed: null,
        icon: const CircularProgressIcon(),
        label: widget.child,
      );
    }

    return FilledButton(
      onPressed: widget.onPressed == null
          ? null
          : () {
              setState(() => _isLoading = true);
              widget.onPressed?.call();
            },
      child: widget.child,
    );
  }
}
