import 'package:flutter/material.dart';

import 'desktop_layout.dart';
import 'mobile_layout.dart';

class LoansPage extends StatelessWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 1100;

      return Scaffold(
        body: isMobile ? const LoansMobileLayout() : const LoansDesktopLayout(),
      );
    });
  }
}
