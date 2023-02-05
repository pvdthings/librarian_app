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

  DateTime? _newDueDate;

  void _saveChanges(BuildContext context) {
    if (_newDueDate != null) {
      _updateDueDate(context);
    }
  }

  void _updateDueDate(BuildContext context) {
    final loans = Provider.of<LoansModel>(context, listen: false);
    loans.updateDueDate(widget.loan.id, _newDueDate!);
  }

  void _closeLoan(BuildContext context) {
    final thingId = widget.loan.thing.id;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thing #$thingId"),
          content:
              Text("Are you sure you want to check Thing #$thingId back in?"),
          actions: [
            TextButton(
              child: const Text("Yes"),
              onPressed: () {
                final things = Provider.of<ThingsModel>(context, listen: false);
                things.checkIn(widget.loan.thing.id);

                final loans = Provider.of<LoansModel>(context, listen: false);
                loans.close(widget.loan.id);

                Navigator.pop(context);
                // TODO: Hide edit button and show that the loan was closed.
                // Going back shows that the loan was removed.
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
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
        editable: _editMode,
        onDueDateUpdated: (newDueDate) {
          setState(() => _newDueDate = newDueDate);
        },
        onClose: () => _closeLoan(context),
      ),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              onPressed: () {
                _saveChanges(context);
                setState(() => _editMode = false);
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.save_rounded),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() => _editMode = true);
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.edit_rounded),
            ),
    );
  }
}
