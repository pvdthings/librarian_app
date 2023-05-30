import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/presentation/desktop_layout.dart';
import 'package:librarian_app/src/features/loans/presentation/loans_mobile_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1100;

        return Scaffold(
            body: isMobile ? const LoansMobileLayout() : const DesktopLayout());
      },
    );
  }
}
