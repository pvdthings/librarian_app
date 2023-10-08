import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/authentication/providers/signin_error_provider.dart';
import 'package:librarian_app/src/features/authentication/widgets/discord_button.dart';
import 'package:librarian_app/src/features/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard_page.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              DiscordSigninButton(
                signIn: ref.read(authServiceProvider).signIn,
                onSignedIn: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                    (route) => false,
                  );
                },
                onError: (error) {
                  ref.read(signinErrorProvider.notifier).state = error;
                },
              ),
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
