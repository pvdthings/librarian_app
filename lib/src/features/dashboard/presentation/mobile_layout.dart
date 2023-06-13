import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/authentication/data/user_view_model.dart';
import 'package:librarian_app/src/features/borrowers/data/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/searchable_borrowers_list.dart';
import 'package:librarian_app/src/features/borrowers/presentation/needs_attention_view.dart';
import 'package:librarian_app/src/features/loans/presentation/checkout/checkout_page.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details_page.dart';
import 'package:librarian_app/src/features/loans/presentation/searchable_loans_list.dart';
import 'package:provider/provider.dart';

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
    SearchableBorrowersList(
      onTapBorrower: _onTapBorrower,
    ),
  ];

  void _onTapBorrower(BorrowerModel borrower) {
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
    final user = Provider.of<UserViewModel>(context);

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
            MaterialPageRoute(builder: (context) => const CheckoutPage()),
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
