import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/widgets/loan_details.dart';
import 'package:librarian_app/lending/widgets/searchable_loans_list.dart';

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  Loan? _selectedLoan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            leading: FloatingActionButton(
              onPressed: () {},
              tooltip: 'Lend Things',
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
              child: SearchableLoansList(
                onLoanTapped: (loan) {
                  setState(() => _selectedLoan = loan);
                },
              ),
            ),
          ),
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(8),
              child: _selectedLoan == null
                  ? const Center(child: Text('Loan Details'))
                  : LoanDetails(
                      borrower: _selectedLoan!.borrower,
                      things: [_selectedLoan!.thing],
                      checkedOutDate: _selectedLoan!.checkedOutDate,
                      dueDate: _selectedLoan!.dueDate,
                      onDueDateUpdated: (_) {},
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
