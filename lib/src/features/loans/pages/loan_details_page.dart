import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/pages/inventory_details_page.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/checkin/checkin_dialog.dart';
import 'package:librarian_app/src/features/loans/widgets/email/send_email_dialog.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_controller.dart';

import '../models/loan_model.dart';
import '../widgets/edit/edit_loan_dialog.dart';

class LoanDetailsPage extends ConsumerStatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final LoanModel loan;

  @override
  ConsumerState<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends ConsumerState<LoanDetailsPage> {
  Future<void> _updateLoan(
      String loanId, String thingId, DateTime newDueDate, String? notes) async {
    final loans = ref.read(loansRepositoryProvider.notifier);
    try {
      await loans.updateLoan(
          loanId: loanId,
          thingId: thingId,
          dueBackDate: newDueDate,
          notes: notes);

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
                        notes: loan.notes,
                        onSavePressed: (newDueDate, notes) async {
                          await _updateLoan(
                              loan.id, loan.thing.id, newDueDate, notes);
                        },
                      );
                    },
                  );
                },
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: loan.borrower.email != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            final controller = LoanDetailsController(
                                context: context, ref: ref);

                            return SendEmailDialog(
                              recipientName: loan.borrower.name,
                              remindersSent: loan.remindersSent,
                              onSend: () async {
                                await controller.sendReminderEmail(
                                    loanNumber: loan.number);
                              },
                            );
                          },
                        );
                      }
                    : null,
                icon: const Icon(Icons.email),
                tooltip: 'Send Email',
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SingleChildScrollView(
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LoanDetails(
                borrower: loan.borrower,
                things: [loan.thing],
                checkedOutDate: loan.checkedOutDate,
                dueDate: loan.dueDate,
                isOverdue: loan.isOverdue,
                notes: loan.notes,
              ),
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
