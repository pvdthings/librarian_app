import 'dart:async';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user.vm.dart';
import 'package:librarian_app/src/features/authentication/pages/signin.page.dart';
import 'package:librarian_app/src/features/dashboard/pages/dashboard.page.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      final viewModel = Provider.of<UserViewModel>(context, listen: false);

      if (!viewModel.signedIn) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const SignInPage()),
          (route) => false,
        );
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const DashboardPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
