import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/authentication/providers/signin_error_provider.dart';
import 'package:librarian_app/src/features/authentication/widgets/discord_button.dart';
import 'package:librarian_app/src/features/authentication/providers/auth_service_provider.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard_page.dart';
import 'package:librarian_app/src/widgets/fade_page_route.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void onSignedIn() {
      Navigator.of(context).pushAndRemoveUntil(
        createFadePageRoute(child: const DashboardPage()),
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
          child: FractionallySizedBox(
            heightFactor: 2 / 5,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      Image.asset(
                        "pvd_things.png",
                        isAntiAlias: true,
                        width: 160,
                      ),
                      const Spacer(),
                      DiscordSigninButton(onPressed: signIn),
                      if (ref.watch(signinErrorProvider) != null) ...[
                        const SizedBox(height: 16),
                        Text(ref.read(signinErrorProvider)!)
                      ],
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
