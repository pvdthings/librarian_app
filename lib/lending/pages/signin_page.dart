import 'package:flutter/material.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  String? _errorMessage;

  Future<void> _signIn() async {
    try {
      await Supabase.instance.client.auth
          .signInWithOAuth(Provider.discord)
          .whenComplete(() => {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LendingPage()),
                  (route) => false,
                )
              });
    } on AuthException catch (error) {
      setState(() => _errorMessage = error.message);
    } catch (error) {
      setState(() => _errorMessage = "An unexpected error occurred.");
    }
  }

  @override
  Widget build(BuildContext context) {
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
              TextButton(
                onPressed: _signIn,
                child: const Text('Sign in with Discord'),
              ),
              if (_errorMessage != null) const SizedBox(height: 16),
              if (_errorMessage != null) Text('Error: $_errorMessage'),
            ],
          ),
        ),
      ),
    );
  }
}
