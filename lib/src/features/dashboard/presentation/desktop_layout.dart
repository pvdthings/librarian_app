import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_desktop_layout.dart';
import 'package:librarian_app/src/features/loans/presentation/checkout_wizard/wizard_page.dart';
import 'package:librarian_app/src/features/loans/presentation/loans_desktop_layout.dart';

class DashboardDesktopLayout extends StatefulWidget {
  const DashboardDesktopLayout({super.key});

  @override
  State<DashboardDesktopLayout> createState() => _DashboardDesktopLayoutState();
}

class _DashboardDesktopLayoutState extends State<DashboardDesktopLayout> {
  int _selectedIndex = 0;

  Widget get _currentScreen {
    if (_selectedIndex == 0) {
      return const LoansDesktopLayout();
    }

    return const BorrowersDesktopLayout();
  }

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
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() => _selectedIndex = index);
          },
        ),
        Expanded(child: Container(child: _currentScreen)),
      ],
    );
  }
}
