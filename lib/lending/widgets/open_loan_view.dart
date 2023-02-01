import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/loans_model.dart';

class OpenLoanView extends StatefulWidget {
  const OpenLoanView({super.key});

  @override
  State<OpenLoanView> createState() => _OpenLoanViewState();
}

class _OpenLoanViewState extends State<OpenLoanView> {
  final _initialDueDate = DateTime.now().add(const Duration(days: 7));
  late final Loan _loan;

  @override
  void initState() {
    _loan = Loan(
      thing: "Hammer",
      borrower: const Borrower(name: "Borrower"),
      dueDate: _initialDueDate,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Text("Borrower"),
              title: Text(_loan.borrower.name),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text("Due Date"),
              title: Text("${_loan.dueDate.month}/${_loan.dueDate.day}"),
              onTap: () async {
                showDatePicker(
                  context: context,
                  initialDate: _initialDueDate,
                  firstDate: _initialDueDate,
                  lastDate: _initialDueDate.add(const Duration(days: 14)),
                ).then((value) {
                  if (value == null) return;

                  setState(() {
                    _loan.dueDate = value;
                  });
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
