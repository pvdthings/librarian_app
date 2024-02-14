import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/widgets/detail.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';
import 'package:librarian_app/src/utils/media_query.dart';

class LoanDetails extends StatelessWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    this.isOverdue = false,
    this.notes,
  });

  final BorrowerModel? borrower;
  final List<ThingSummaryModel> things;
  final String? notes;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    const iconPlaceholder = SizedBox.square(dimension: 16);

    final isMobileScreen = isMobile(context);
    final double cardElevation = isMobileScreen ? 1 : 0;

    final borrowerCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          const Detail(
            useListTile: true,
            prefixIcon: Icon(Icons.person),
            label: 'Borrower',
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            label: 'Name',
            value: borrower!.name,
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            label: 'Email',
            placeholderText: '-',
            value: borrower!.email,
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            label: 'Phone',
            placeholderText: '-',
            value: borrower!.phone,
          ),
        ],
      ),
    );

    final thingsCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          const Detail(
            useListTile: true,
            label: 'Thing',
            prefixIcon: Icon(Icons.build_rounded),
          ),
          ...things.map((thing) {
            return Detail(
              useListTile: true,
              prefixIcon: iconPlaceholder,
              value: '#${thing.number} ${thing.name}',
            );
          })
        ],
      ),
    );

    final datesCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          Detail(
            useListTile: true,
            prefixIcon: Builder(
              builder: (_) {
                if (!isOverdue) {
                  return const Icon(Icons.calendar_month);
                }

                return const Tooltip(
                  message: 'Overdue',
                  child: Icon(
                    Icons.calendar_month,
                    color: Colors.amber,
                  ),
                );
              },
            ),
            label: 'Dates',
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            label: 'Checked Out',
            value:
                '${checkedOutDate.month}/${checkedOutDate.day}/${checkedOutDate.year}',
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            label: 'Due Back',
            value: '${dueDate.month}/${dueDate.day}/${dueDate.year}',
          ),
        ],
      ),
    );

    final notesCard = Card(
      elevation: cardElevation,
      child: Column(
        children: [
          const Detail(
            useListTile: true,
            prefixIcon: Icon(Icons.notes),
            label: 'Notes',
          ),
          Detail(
            useListTile: true,
            prefixIcon: iconPlaceholder,
            value: notes,
            placeholderText: '-',
          ),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            children: [
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: thingsCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: datesCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: notesCard,
              ),
              FractionallySizedBox(
                widthFactor: isMobileScreen ? 1 : 0.5,
                child: borrowerCard,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
