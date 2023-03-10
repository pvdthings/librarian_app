import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/user_model.dart';
import 'package:librarian_app/lending/pages/open_loan_page.dart';
import 'package:librarian_app/lending/widgets/borrowers_list_view.dart';
import 'package:librarian_app/lending/widgets/loans_list_view.dart';
import 'package:provider/provider.dart';

class LendingPage extends StatefulWidget {
  const LendingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LendingPageState();
  }
}

class _LendingPageState extends State<LendingPage> {
  int _viewIndex = 0;

  static final _views = [
    const LoansListView(),
    BorrowersListView(
      onTapBorrower: (Borrower borrower) {},
    ),
  ];

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
          onPressed: user.signOut,
          icon: const Icon(
            Icons.logout_rounded,
          ),
        ),
      ),
      body: _views[_viewIndex],
      bottomNavigationBar: BottomNavigationBar(
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
