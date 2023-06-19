import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details_pane.dart';
import 'package:librarian_app/src/features/loans/presentation/loans_list.dart';
import 'package:provider/provider.dart';

import '../data/loans_view_model.dart';

class LoansDesktopLayout extends StatefulWidget {
  const LoansDesktopLayout({super.key});

  @override
  State<LoansDesktopLayout> createState() => _LoansDesktopLayoutState();
}

class _LoansDesktopLayoutState extends State<LoansDesktopLayout> {
  final _searchController = TextEditingController();
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          child: SizedBox(
            width: 500,
            child: Consumer<LoansViewModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    PaneHeader(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() => _searchFilter = value);
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Search...',
                          icon: Icon(
                            Icons.search_rounded,
                            color: _searchFilter.isEmpty
                                ? null
                                : Theme.of(context).primaryIconTheme.color,
                          ),
                          suffixIcon: _searchFilter.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchFilter = '';
                                    });
                                    model.clearSelectedLoan();
                                  },
                                  icon: const Icon(Icons.clear_rounded),
                                  tooltip: 'Clear Search',
                                ),
                        ),
                      ),
                    ),
                    const Divider(),
                    LoansList(
                      loans: model.filtered(_searchFilter),
                      selected: model.selectedLoan,
                      onTap: (loan) => model.selectedLoan = loan,
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
