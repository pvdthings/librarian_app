import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/save_dialog.widget.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details_page.dart';
import 'package:librarian_app/src/features/loans/data/loans.vm.dart';
import 'package:librarian_app/src/features/loans/widgets/checkin/checkin_dialog.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details.widget.dart';
import 'package:provider/provider.dart';

import '../data/loan.model.dart';

class LoanDetailsPage extends StatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final LoanModel loan;

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  bool get _changesMade => _newDueDate != null;

  DateTime? _newDueDate;

  void _discardChanges() {
    setState(() => _newDueDate = null);
  }

  Future<void> _saveChanges(String loanId, String thingId) async {
    if (_newDueDate != null && await showSaveDialog(context)) {
      await _updateDueDate(loanId, thingId);
    }
  }

  Future<void> _updateDueDate(String loanId, String thingId) async {
    final loans = Provider.of<LoansViewModel>(context, listen: false);
    try {
      await loans.updateDueDate(
        loanId: loanId,
        thingId: thingId,
        dueBackDate: _newDueDate!,
      );

      setState(() {
        _newDueDate = null;
        _loanFuture = loans.getLoan(id: loanId, thingId: thingId);
      });
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  void _checkIn() async {
    showDialog<bool>(
      context: context,
      builder: (context) {
        final thing = widget.loan.thing;
        return CheckinDialog(
          thingNumber: thing.number,
          onCheckin: () async {
            final loans = Provider.of<LoansViewModel>(context, listen: false);
            await loans.closeLoan(
              loanId: widget.loan.id,
              thingId: widget.loan.thing.id,
            );
          },
        );
      },
    ).then((result) {
      if (result ?? false) {
        Navigator.of(context).pop();
      }
    });
  }

  late Future<LoanModel?> _loanFuture;

  @override
  void initState() {
    super.initState();
    final loan = widget.loan;
    _loanFuture = context
        .read<LoansViewModel>()
        .getLoan(id: loan.id, thingId: loan.thing.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansViewModel>(
      builder: (context, loans, child) {
        return FutureBuilder(
          future: _loanFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return loadingScaffold;
            }

            if (loans.errorMessage != null) {
              return errorScaffold(loans.errorMessage!);
            }

            final loan = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: const Text("Loan Details"),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: _changesMade
                        ? () => _saveChanges(loan.id, loan.thing.id)
                        : null,
                    icon: const Icon(Icons.save_rounded),
                    tooltip: 'Save',
                  ),
                  IconButton(
                    onPressed: _changesMade ? _discardChanges : null,
                    icon: const Icon(Icons.cancel),
                    tooltip: 'Discard Changes',
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
                  editable: true,
                  onDueDateUpdated: (newDueDate) {
                    setState(() => _newDueDate = newDueDate);
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _checkIn,
                tooltip: 'Check in',
                child: const Icon(Icons.check_rounded),
              ),
            );
          },
        );
      },
    );
  }
}
