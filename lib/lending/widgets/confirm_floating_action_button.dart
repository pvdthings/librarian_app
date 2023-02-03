import 'package:flutter/material.dart';

class ConfirmFloatingActionButton extends StatefulWidget {
  const ConfirmFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.backgroundColor,
  });

  final Icon icon;
  final String label;
  final Function() onPressed;
  final Color? backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return _ConfirmFloatingActionButtonState();
  }
}

class _ConfirmFloatingActionButtonState
    extends State<ConfirmFloatingActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return !_pressed
        ? FloatingActionButton(
            onPressed: () {
              setState(() => _pressed = true);
            },
            backgroundColor: widget.backgroundColor,
            child: widget.icon,
          )
        : FloatingActionButton.extended(
            onPressed: widget.onPressed,
            icon: widget.icon,
            label: Text(widget.label),
            backgroundColor: widget.backgroundColor,
          );
  }
}
