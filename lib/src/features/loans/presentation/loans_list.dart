import 'package:flutter/material.dart';

import '../data/loan_model.dart';

class LoansList extends StatelessWidget {
  final List<LoanModel> loans;
  final LoanModel? selected;
  final void Function(LoanModel loan)? onTap;

  const LoansList({
    super.key,
    required this.loans,
    this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];

        return ListTile(
          title: Text(loan.thing.name ?? 'Unknown Thing'),
          subtitle: Text(loan.borrower.name),
          trailing: loan.isOverdue
              ? const Tooltip(
                  message: 'Overdue',
                  child: Icon(Icons.warning_rounded),
                )
              : Text(
                  loan.isDueToday
                      ? 'Today'
                      : '${loan.dueDate.month}/${loan.dueDate.day}',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  ),
                ),
          selected:
              loan.id == selected?.id && loan.thing.id == selected?.thing.id,
          onTap: () => onTap?.call(loan),
        );
      },
      shrinkWrap: true,
    );
  }
}
