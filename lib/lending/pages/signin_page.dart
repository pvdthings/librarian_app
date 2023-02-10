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
  String? _error;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.asset(
              "pvd_things.png",
              width: 256,
            ),
            const SizedBox(height: 16),
            TextField(
              onSubmitted: (value) {
                try {
                  user.signIn(pin: value);
                } catch (e) {
                  setState(() => _error = e.toString());
                }
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.key_rounded),
                labelText: "PIN",
                hintText: "User PIN",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            if (_error != null)
              Center(
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
