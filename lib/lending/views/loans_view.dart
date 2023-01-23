import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/pages/loan_details_page.dart';
import 'package:provider/provider.dart';

class LoansView extends StatelessWidget {
  const LoansView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansModel>(
      builder: (context, model, child) {
        final loans = model.getAll();

        return ListView.builder(
          itemCount: loans.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(loans[index].borrower.name),
              subtitle: Text(loans[index].things),
              trailing: Chip(
                label: Text(loans[index].due),
                backgroundColor:
                    loans[index].isOverdue ? Colors.red[100] : null,
              ),
              tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
              hoverColor: Colors.grey[100],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoanDetailsPage()),
                );
              },
            );
          },
        );
      },
    );
  }
}
