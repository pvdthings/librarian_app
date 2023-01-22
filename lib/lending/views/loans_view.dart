import 'package:flutter/material.dart';
import 'package:librarian_app/lending/pages/loan_details_page.dart';

class LoansView extends StatelessWidget {
  const LoansView({super.key});

  static final List<Map<String, String>> _loans = [
    {
      "name": "Alice",
      "things": "Chainsaw, Shovel, Rubber Gloves",
      "due": "Today",
    },
    {
      "name": "Bob",
      "things": "Coventry-opoly",
      "due": "10/31",
    }
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _loans.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_loans[index]["name"] as String),
          subtitle: Text(_loans[index]["things"] as String),
          trailing: Chip(
            label: Text(_loans[index]["due"] as String),
          ),
          tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
          hoverColor: Colors.grey[100],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoanDetailsPage()),
            );
          },
        );
      },
    );
  }
}
