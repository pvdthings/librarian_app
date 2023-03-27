import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
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

  String? _errorMessage;

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
      print(error);
    }
  }

  Future<void> _closeLoan(String loanId, String thingId) async {
    final loans = Provider.of<LoansModel>(context, listen: false);
    await loans.closeLoan(loanId: loanId, thingId: thingId);

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
        checkedOutDate: loan.checkedOutDate,
        dueDate: _newDueDate ?? loan.dueDate,
        checkedInDate: loan.checkedInDate,
        editable: _editMode,
        onDueDateUpdated: (newDueDate) {
          setState(() => _newDueDate = newDueDate);
        },
        onClose: (thingId) => _closeLoan(loan.id, thingId),
      ),
      floatingActionButton: _editable
          ? _editMode
              ? FloatingActionButton(
                  onPressed: () => _saveChanges(loan.id, loan.thing.id),
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
