import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user_model.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list_view.dart';
import 'package:librarian_app/src/features/borrowers/presentation/needs_attention_view.dart';
import 'package:provider/provider.dart';

import '../../loans/presentation/loan_details_page.dart';
import '../../loans/presentation/open_loan_page.dart';
import '../../loans/presentation/searchable_loans_list.dart';

class DashboardMobileLayout extends StatefulWidget {
  const DashboardMobileLayout({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DashboardMobileLayoutState();
  }
}

class _DashboardMobileLayoutState extends State<DashboardMobileLayout> {
  int _viewIndex = 0;

  late final _views = [
    SearchableLoansList(
      onLoanTapped: (loan) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanDetailsPage(loan),
          ),
        );
      },
    ),
    BorrowersListView(
      onTapBorrower: _onTapBorrower,
    ),
  ];

  void _onTapBorrower(Borrower borrower) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text(borrower.name)),
        body: NeedsAttentionView(borrower: borrower),
      );
    }));
  }

  static final _titles = [
    "Loans",
    "Borrowers",
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_viewIndex]),
        leading: IconButton(
          onPressed: () {
            user.signOut();
            Navigator.of(context).popAndPushNamed('/');
          },
          icon: const Icon(
            Icons.logout_rounded,
          ),
        ),
      ),
      body: _views[_viewIndex],
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _viewIndex,
          onTap: (index) => setState(() {
            _viewIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.table_chart_rounded),
              label: "Loans",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_rounded),
              label: "Borrowers",
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OpenLoanPage()),
          );
        },
        child: const Icon(
          Icons.add_rounded,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
