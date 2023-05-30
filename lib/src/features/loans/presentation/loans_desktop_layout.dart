import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details_pane.dart';
import 'package:provider/provider.dart';

import '../data/loans_model.dart';
import 'searchable_loans_list.dart';

class LoansDesktopLayout extends StatefulWidget {
  const LoansDesktopLayout({super.key});

  @override
  State<LoansDesktopLayout> createState() => _LoansDesktopLayoutState();
}

class _LoansDesktopLayoutState extends State<LoansDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          child: Card(
            child: SizedBox(
              width: 500,
              child: Consumer<LoansModel>(
                builder: (context, loans, child) {
                  return SearchableLoansList(
                    onLoanTapped: (loan) {
                      loans.selectedLoan = loan;
                    },
                    selectedLoan: loans.selectedLoan,
                  );
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<LoansModel>(
            builder: (context, loans, child) {
              return Container(
                margin: const EdgeInsets.all(8),
                child: LoanDetailsPane(
                  loan: loans.selectedLoan,
                  onSave: (newDueDate) {
                    loans.updateDueDate(
                      loanId: loans.selectedLoan!.id,
                      thingId: loans.selectedLoan!.thing.id,
                      dueBackDate: newDueDate,
                    );
                  },
                  onCheckIn: () {
                    loans
                        .closeLoan(
                      loanId: loans.selectedLoan!.id,
                      thingId: loans.selectedLoan!.thing.id,
                    )
                        .whenComplete(() {
                      setState(() => loans.selectedLoan = null);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
