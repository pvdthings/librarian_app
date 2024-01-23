import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/authentication/providers/signin_error_provider.dart';
import 'package:librarian_app/src/features/authentication/widgets/discord_button.dart';
import 'package:librarian_app/src/features/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSignedIn() {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardPage()),
        (route) => false,
      );
    }

    Future<void> signIn() async {
      if (kDebugMode) {
        onSignedIn();
        return;
      }

      try {
        await ref.read(authServiceProvider).signIn();
        onSignedIn();
      } on AuthException catch (error) {
        ref.read(signinErrorProvider.notifier).state = error.toString();
      } catch (error) {
        ref.read(signinErrorProvider.notifier).state =
            "An unexpected error occurred.";
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "pvd_things.png",
                isAntiAlias: true,
                width: 160,
              ),
              const SizedBox(height: 32),
              DiscordSigninButton(onPressed: signIn),
              if (ref.watch(signinErrorProvider) != null) ...[
                const SizedBox(height: 16),
                Text(ref.read(signinErrorProvider)!)
              ],
              const SizedBox(height: 32),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Only authorized users can sign in.\nPlease ask the PVD Things Digital Team for volunteer access.'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
