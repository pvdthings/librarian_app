import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/presentation/desktop_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: DesktopLayout());
  }
}
