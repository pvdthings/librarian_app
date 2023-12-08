import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details_page.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/checkin/checkin_dialog.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details.dart';

import '../models/loan_model.dart';
import '../widgets/edit/edit_loan_dialog.dart';

class LoanDetailsPage extends ConsumerStatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final LoanModel loan;

  @override
  ConsumerState<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends ConsumerState<LoanDetailsPage> {
  Future<void> _updateDueDate(
      String loanId, String thingId, DateTime newDueDate) async {
    final loans = ref.read(loansRepositoryProvider.notifier);
    try {
      await loans.updateDueDate(
        loanId: loanId,
        thingId: thingId,
        dueBackDate: newDueDate,
      );

      setState(() {
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
            final loans = ref.read(loansRepositoryProvider.notifier);
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
        .read(loansRepositoryProvider.notifier)
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
            title: Text('#${loan.thing.number}'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditLoanDialog(
                        dueDate: loan.dueDate,
                        onSavePressed: (newDueDate) async {
                          await _updateDueDate(
                              loan.id, loan.thing.id, newDueDate);
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: LoanDetails(
              borrower: loan.borrower,
              things: [loan.thing],
              checkedOutDate: loan.checkedOutDate,
              dueDate: loan.dueDate,
              isOverdue: loan.isOverdue,
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
