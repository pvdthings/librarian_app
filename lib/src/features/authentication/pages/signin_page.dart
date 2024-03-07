import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/core/library.dart';
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
        ref.read(authServiceProvider).signIn().then((_) => onSignedIn());
      } on AuthException catch (error) {
        ref.read(signinErrorProvider.notifier).state = error.toString();
      } catch (error) {
        ref.read(signinErrorProvider.notifier).state =
            "An unexpected error occurred.";
      }
    }

    final card = Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            _LogoImage(),
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
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: FractionallySizedBox(
            heightFactor: 2 / 5,
            child: AspectRatio(
              aspectRatio: 1 / 1,
              child: card,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Library.logoUrl != null) {
      return Image.network(
        Library.logoUrl!,
        loadingBuilder: (context, child, progress) {
          return Center(child: child);
        },
        isAntiAlias: true,
        width: 160,
      );
    }

    return const Icon(
      Icons.local_library_outlined,
      size: 160,
    );
  }
}
