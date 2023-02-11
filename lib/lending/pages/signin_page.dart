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
  bool _showSubmitButton = false;
  String? _error;

  final _pinController = TextEditingController();

  void _submit(UserModel user, String value) {
    try {
      user.signIn(pin: value);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

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
              isAntiAlias: true,
              width: 160,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _pinController,
              onSubmitted: (value) => _submit(user, value),
              onChanged: (value) {
                setState(() => _showSubmitButton = value.isNotEmpty);
              },
              decoration: InputDecoration(
                icon: const Icon(Icons.key_rounded),
                suffixIcon: _showSubmitButton
                    ? IconButton(
                        onPressed: () => _submit(user, _pinController.text),
                        icon: const Icon(Icons.keyboard_return_rounded),
                      )
                    : null,
                labelText: "PIN",
                hintText: "User PIN",
                border: const OutlineInputBorder(),
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
