import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/presentation/checkout_stepper/checkout_stepper.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: false,
      ),
      body: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: const CheckoutStepper(),
      ),
    );
  }
}
