import 'package:flutter/material.dart';
import 'package:librarian_app/lending/views/add_things_view.dart';
import 'package:librarian_app/lending/views/open_loan_view.dart';
import 'package:librarian_app/lending/views/select_borrower_view.dart';

class OpenLoanPage extends StatefulWidget {
  const OpenLoanPage({super.key});

  @override
  State<OpenLoanPage> createState() => _OpenLoanPageState();
}

class _OpenLoanPageState extends State<OpenLoanPage> {
  int _viewIndex = 0;

  static final _views = [
    const SelectBorrowerView(),
    const AddThingsView(),
    const OpenLoanView(),
  ];

  static final _titles = [
    "Select Borrower",
    "Add Things",
    "Loan Details",
  ];

  bool get _isFinishStep => _viewIndex == _titles.length - 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_viewIndex])),
      body: _views[_viewIndex],
      floatingActionButton: _isFinishStep
          ? FloatingActionButton(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.check_rounded,
                size: 30,
              ),
            )
          : FloatingActionButton(
              onPressed: () => setState(() {
                _viewIndex += 1;
              }),
              backgroundColor: Colors.orange,
              child: const Icon(
                Icons.navigate_next_rounded,
                size: 30,
              ),
            ),
    );
  }
}
