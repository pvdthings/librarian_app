import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/data/loans_model.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details.dart';
import 'package:provider/provider.dart';

import '../../dashboard/presentation/mobile_layout.dart';

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
  }

  void _checkIn() {
    showDialog(
      context: context,
      builder: (context) {
        final thing = widget.loan.thing;
        return AlertDialog(
          title: Text("Thing #${thing.number}"),
          content: Text(
              "Are you sure you want to check Thing #${thing.number} back in?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                await _closeLoan(widget.loan.id, thing.id);

                Future.delayed(
                  Duration.zero,
                  () {
                    Navigator.of(context).pop();
                    return Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(
                      builder: (context) {
                        return const DashboardMobileLayout();
                      },
                    ), (route) => false);
                  },
                );
              },
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
      appBar: AppBar(
        title: const Text("Loan Details"),
        centerTitle: true,
        actions: [
          if (_editMode && _changesMade)
            IconButton(
              onPressed: () => _saveChanges(loan.id, loan.thing.id),
              icon: const Icon(Icons.save_rounded),
              tooltip: 'Save',
            ),
          _editMode
              ? IconButton(
                  onPressed: () => setState(() => _editMode = false),
                  icon: const Icon(Icons.close_rounded),
                  tooltip: 'Cancel',
                )
              : IconButton(
                  onPressed: () => setState(() => _editMode = true),
                  icon: const Icon(Icons.edit_rounded),
                  tooltip: 'Edit',
                ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LoanDetails(
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
        ),
      ),
      floatingActionButton: _editMode
          ? null
          : FloatingActionButton(
              onPressed: _checkIn,
              tooltip: 'Check in',
              child: const Icon(Icons.check_rounded),
            ),
    );
  }
}
