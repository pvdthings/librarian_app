import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details_pane.dart';
import 'package:librarian_app/src/features/loans/views/loans_view.dart';
import 'package:provider/provider.dart';

import '../data/loans_view_model.dart';

class LoansDesktopLayout extends StatefulWidget {
  const LoansDesktopLayout({super.key});

  @override
  State<LoansDesktopLayout> createState() => _LoansDesktopLayoutState();
}

class _LoansDesktopLayoutState extends State<LoansDesktopLayout> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 500,
            child: Consumer<LoansViewModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    PaneHeader(
                      child: SearchField(
                        onChanged: (value) {
                          setState(() => _searchFilter = value);
                        },
                        onClearPressed: () {
                          setState(() => _searchFilter = '');
                          model.clearSelectedLoan();
                        },
                      ),
                    ),
                    Expanded(
                      child: LoansView(
                        model: model,
                        searchFilter: _searchFilter,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Consumer<LoansViewModel>(
            builder: (context, loans, child) {
              return LoanDetailsPane(
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
              );
            },
          ),
        ),
      ],
    );
  }
}
