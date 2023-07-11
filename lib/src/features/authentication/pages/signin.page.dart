import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user.vm.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard.page.dart';
import 'package:provider/provider.dart';
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

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const DashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Consumer<UserViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "pvd_things.png",
                    isAntiAlias: true,
                    width: 160,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.discord_rounded),
                    label: const Text('Sign in with Discord'),
                    onPressed: () async {
                      if (kDebugMode) {
                        _navigateToDashboard();
                        return;
                      }

                      try {
                        await viewModel.signIn();
                        _navigateToDashboard();
                      } on AuthException catch (error) {
                        setState(() => _errorMessage = error.message);
                      } catch (error) {
                        setState(() =>
                            _errorMessage = "An unexpected error occurred.");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 20),
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                  if (_errorMessage != null) const SizedBox(height: 16),
                  if (_errorMessage != null) Text(_errorMessage!),
                  const SizedBox(height: 32),
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'Only authorized users can sign in.\nPlease ask the PVD Things Digital Team for volunteer access.'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
