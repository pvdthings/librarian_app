import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/media_query.dart';

import '../../data/loan.model.dart';

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

  String _getBorrowerInitials(String name) {
    final uppercaseName = name.toUpperCase();
    final firstLetter = uppercaseName[0];

    final split = uppercaseName.split(' ');
    final secondLetter = split.length > 1 ? split[1][0] : uppercaseName[1];

    return firstLetter + secondLetter;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: loans.length,
      itemBuilder: (context, index) {
        final loan = loans[index];

        final thingNumber = Text('#${loan.thing.number}');
        final thingName = Text(loan.thing.name ?? 'Unknown Thing');
        final borrowerInitials = _getBorrowerInitials(loan.borrower.name);

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.black38,
            child: Text(borrowerInitials),
          ),
          title: thingName,
          subtitle: thingNumber,
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
          selected: isMobile(context)
              ? false
              : loan.id == selected?.id && loan.thing.id == selected?.thing.id,
          onTap: () => onTap?.call(loan),
        );
      },
      shrinkWrap: true,
    );
  }
}
