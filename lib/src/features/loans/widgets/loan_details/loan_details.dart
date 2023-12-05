import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/common/widgets/detail.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';

class LoanDetails extends StatelessWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    this.isOverdue = false,
    this.checkedInDate,
  });

  final BorrowerModel? borrower;
  final List<ThingSummaryModel> things;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final DateTime? checkedInDate;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Detail(
            label: 'Borrower',
            value: borrower!.name,
          ),
          const SizedBox(height: 32),
          ...things.map((thing) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Detail(
                label: 'Thing',
                value: '#${thing.number} ${thing.name}',
              ),
            );
          }),
          const SizedBox(height: 16),
          Wrap(
            runSpacing: 16,
            children: [
              Detail(
                label: 'Checked Out',
                value:
                    '${checkedOutDate.month}/${checkedOutDate.day}/${checkedOutDate.year}',
              ),
              const SizedBox(width: 16),
              Detail(
                label: 'Due Back',
                value: '${dueDate.month}/${dueDate.day}/${dueDate.year}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
