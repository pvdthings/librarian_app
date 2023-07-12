import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/dashboard/loan_details_pane.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/loans_view.widget.dart';
import 'package:provider/provider.dart';

import '../../data/loans.vm.dart';

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
        Consumer<LoansViewModel>(
          builder: (context, loans, child) {
            return ListPane(
              header: PaneHeader(
                child: SearchField(
                  onChanged: (value) {
                    setState(() => _searchFilter = value);
                  },
                  onClearPressed: () {
                    setState(() => _searchFilter = '');
                    loans.clearSelectedLoan();
                  },
                ),
              ),
              child: LoansView(
                model: loans,
                searchFilter: _searchFilter,
              ),
            );
          },
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
