import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';

class LoanDetails extends StatelessWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    required this.onDueDateUpdated,
    this.isOverdue = false,
    this.checkedInDate,
    this.editable = true,
  });

  final bool editable;
  final BorrowerModel? borrower;
  final List<ThingSummaryModel> things;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final DateTime? checkedInDate;
  final bool isOverdue;

  final void Function(DateTime) onDueDateUpdated;

  void showDateSelection(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: dueDate,
      firstDate: dueDate,
      lastDate: dueDate.add(const Duration(days: 14)),
    ).then((value) {
      if (value == null) return;
      onDueDateUpdated(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Detail(label: 'Borrower', value: borrower!.name),
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

class Detail extends StatelessWidget {
  const Detail({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.black38,
          ),
          child: Text(
            value,
            style:
                Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
