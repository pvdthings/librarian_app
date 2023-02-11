import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:librarian_app/lending/widgets/loan_details.dart';
import 'package:provider/provider.dart';

class LoanDetailsPage extends StatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final Loan loan;

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  bool _editMode = false;
  bool _editable = true;

  DateTime? _newDueDate;

  void _saveChanges(BuildContext context) {
    if (_newDueDate != null) {
      _updateDueDate(context);
    }

    setState(() => _editMode = false);
  }

  void _updateDueDate(BuildContext context) {
    final loans = Provider.of<LoansModel>(context, listen: false);
    loans.updateDueDate(widget.loan.id, _newDueDate!);
  }

  void _closeLoan(int thingId) {
    final things = Provider.of<ThingsModel>(context, listen: false);
    things.checkIn(widget.loan.thing.id);

    final loans = Provider.of<LoansModel>(context, listen: false);
    loans.close(widget.loan.id);

    setState(() {
      _editable = false;
      _editMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Scaffold(
      appBar: AppBar(title: const Text("Loan Details")),
      body: LoanDetails(
        borrower: loan.borrower,
        things: [loan.thing],
        dueDate: _newDueDate ?? loan.dueDate,
        checkedInDate: loan.checkedInDate,
        editable: _editMode,
        onDueDateUpdated: (newDueDate) {
          setState(() => _newDueDate = newDueDate);
        },
        onClose: _closeLoan,
      ),
      floatingActionButton: _editable
          ? _editMode
              ? FloatingActionButton(
                  onPressed: () => _saveChanges(context),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.save_rounded),
                )
              : FloatingActionButton(
                  onPressed: () {
                    setState(() => _editMode = true);
                  },
                  child: const Icon(Icons.edit_rounded),
                )
          : null,
    );
  }
}
