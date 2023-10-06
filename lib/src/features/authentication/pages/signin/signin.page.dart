import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user.vm.dart';
import 'package:librarian_app/src/features/authentication/pages/signin/widgets/discord_button.widget.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard_page.dart';
import 'package:provider/provider.dart';

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
                  DiscordSigninButton(
                    signIn: viewModel.signIn,
                    onSignedIn: _navigateToDashboard,
                    onError: (error) {
                      setState(() => _errorMessage = error);
                    },
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
