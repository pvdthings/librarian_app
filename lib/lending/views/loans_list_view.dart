import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/pages/loan_details_page.dart';
import 'package:provider/provider.dart';

class LoansListView extends StatelessWidget {
  const LoansListView({super.key});

  Color? _dueDateBackgroundColor(Loan loan) {
    if (loan.isOverdue) return Colors.red[100];
    if (loan.isDueToday) return Colors.green[100];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansModel>(
      builder: (context, model, child) {
        final loans = model.getAll();

        return ListView.builder(
          itemCount: loans.length,
          itemBuilder: (context, index) {
            final loan = loans[index];

            return ListTile(
              title: Text(loan.thing),
              subtitle: Text(loan.borrower.name),
              trailing: Chip(
                label: Text(loan.dueDate.toString()),
                backgroundColor: _dueDateBackgroundColor(loan),
              ),
              tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
              hoverColor: Colors.grey[100],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoanDetailsPage(),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
