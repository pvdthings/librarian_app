import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/save_dialog.widget.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details_page.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/checkin/checkin_dialog.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details.widget.dart';

import '../data/loan.model.dart';

class LoanDetailsPage extends ConsumerStatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final LoanModel loan;

  @override
  ConsumerState<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends ConsumerState<LoanDetailsPage> {
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
    final loans = ref.read(loansRepositoryProvider);
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
            final loans = ref.read(loansRepositoryProvider);
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
    _loanFuture = ref
        .read(loansRepositoryProvider)
        .getLoan(id: loan.id, thingId: loan.thing.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loanFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadingScaffold;
        }

        if (snapshot.hasError) {
          return errorScaffold(snapshot.error.toString());
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
  }
}
