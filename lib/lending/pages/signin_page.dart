import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/user_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SignInPageState();
  }
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

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
                onPressed: user.signIn,
                child: const Text('Sign in with Discord'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
