import 'package:flutter/material.dart';
import 'package:librarian_app/lending/views/loans_view.dart';
import 'package:librarian_app/lending/views/profile_view.dart';
import 'package:librarian_app/lending/views/select_member_view.dart';

class LendingPage extends StatefulWidget {
  const LendingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LendingPageState();
  }
}

class _LendingPageState extends State<LendingPage> {
  int _viewIndex = 0;
  final _views = [
    const LoansView(),
    const SelectMemberView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.add_circle_rounded),
            label: "Open Loan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: "Me",
          ),
        ],
        backgroundColor: Colors.blue,
        iconSize: 30,
        selectedItemColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
