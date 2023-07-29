import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DiscordSigninButton extends StatelessWidget {
  final Future<void> Function()? signIn;
  final void Function()? onSignedIn;
  final void Function(String)? onError;

  const DiscordSigninButton({
    super.key,
    this.signIn,
    this.onSignedIn,
    this.onError,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.discord_rounded),
      label: const Text('Sign in with Discord'),
      onPressed: () async {
        if (kDebugMode) {
          onSignedIn?.call();
          return;
        }

        try {
          await signIn?.call();
          onSignedIn?.call();
        } on AuthException catch (error) {
          onError?.call(error.toString());
        } catch (error) {
          onError?.call("An unexpected error occurred.");
        }
      },
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
