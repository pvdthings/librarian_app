import 'package:flutter/material.dart';
import 'package:librarian_app/views/placeholder_view.dart';

class LoanDetailsPage extends StatelessWidget {
  const LoanDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loan Details")),
      body: const PlaceholderView(title: "Loan Details"),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.edit_rounded,
          size: 30,
        ),
      ),
    );
  }
}
