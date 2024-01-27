import 'package:flutter/material.dart';

class DiscordSigninButton extends StatelessWidget {
  const DiscordSigninButton({super.key, required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.discord_rounded),
      label: const Text('Sign in with Discord'),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
