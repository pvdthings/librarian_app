import 'package:flutter/material.dart';
import 'package:librarian_app/lending/views/select_borrower_view.dart';

class OpenLoanPage extends StatelessWidget {
  const OpenLoanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Open Loan")),
      body: const SelectBorrowerView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.navigate_next_rounded,
          size: 30,
        ),
      ),
    );
  }
}
