import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
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
  bool _changesMade = false;

  DateTime? _newDueDate;

  Future<void> _saveChanges(String loanId, String thingId) async {
    if (_newDueDate != null) {
      await _updateDueDate(loanId, thingId);
    }

    setState(() => _editMode = false);
  }

  Future<void> _updateDueDate(String loanId, String thingId) async {
    final loans = Provider.of<LoansModel>(context, listen: false);
    try {
      await loans.updateDueDate(
        loanId: loanId,
        thingId: thingId,
        dueBackDate: _newDueDate!,
      );
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<void> _closeLoan(String loanId, String thingId) async {
    final loans = Provider.of<LoansModel>(context, listen: false);
    await loans.closeLoan(loanId: loanId, thingId: thingId);

    // ignore: use_build_context_synchronously
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const LendingPage();
        },
      ),
      (route) => false,
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
        checkedOutDate: loan.checkedOutDate,
        dueDate: _newDueDate ?? loan.dueDate,
        checkedInDate: loan.checkedInDate,
        isOverdue: loan.isOverdue,
        editable: _editMode,
        onDueDateUpdated: (newDueDate) {
          setState(() {
            _newDueDate = newDueDate;
            _changesMade = true;
          });
        },
        onClose: (thingId) => _closeLoan(loan.id, thingId),
      ),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              onPressed: _changesMade
                  ? () => _saveChanges(loan.id, loan.thing.id)
                  : () => setState(() => _editMode = false),
              backgroundColor: _changesMade ? Colors.green : Colors.grey[600],
              tooltip: _changesMade ? 'Save changes' : 'Cancel',
              child: _changesMade
                  ? const Icon(Icons.check_rounded)
                  : const Icon(Icons.close_rounded),
            )
          : FloatingActionButton(
              onPressed: () => setState(() => _editMode = true),
              tooltip: 'Edit',
              child: const Icon(Icons.edit_rounded),
            ),
    );
  }
}
