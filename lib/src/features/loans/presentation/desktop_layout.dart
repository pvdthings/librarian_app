import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/presentation/desktop_layout/loan_details_pane.dart';
import 'package:librarian_app/src/features/loans_wizard/presentation/wizard_page.dart';
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
        NavigationRail(
          leading: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (c) => const WizardPage()));
            },
            tooltip: 'New Loan',
            child: const Icon(Icons.add_rounded),
          ),
          labelType: NavigationRailLabelType.selected,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.table_chart_rounded),
              label: Text('Loans'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people_rounded),
              label: Text('Borrowers'),
            ),
          ],
          selectedIndex: 0,
        ),
        Card(
          margin: const EdgeInsets.all(8),
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
        Expanded(
          child: Consumer<LoansModel>(
            builder: (context, loans, child) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: loans.selectedLoan == null
                    ? const Center(child: Text('Loan Details'))
                    : LoanDetailsPane(
                        loan: loans.selectedLoan,
                        onSave: () {},
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
