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
          TextField(
            controller: TextEditingController(text: borrower?.name),
            readOnly: true,
            decoration: const InputDecoration(
              icon: Icon(Icons.person_rounded),
              labelText: 'Borrower',
              border: OutlineInputBorder(),
              constraints: BoxConstraints(maxWidth: 500),
            ),
          ),
          const SizedBox(height: 32),
          ...things.map((thing) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: TextEditingController(
                    text: '${thing.name} #${thing.number}'),
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.build_rounded),
                  labelText: 'Thing',
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints(maxWidth: 500),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              TextField(
                controller: TextEditingController(
                    text: '${checkedOutDate.month}/${checkedOutDate.day}'),
                readOnly: true,
                decoration: const InputDecoration(
                  icon: Icon(Icons.calendar_month_rounded),
                  labelText: 'Checked Out',
                  border: OutlineInputBorder(),
                  constraints: BoxConstraints(maxWidth: 200),
                ),
              ),
              TextField(
                controller: TextEditingController(
                    text: '${dueDate.month}/${dueDate.day}'),
                readOnly: !editable,
                onTap: () {
                  if (editable) {
                    showDateSelection(context);
                  }
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_month_rounded),
                  iconColor: isOverdue ? Colors.orange : null,
                  suffixIcon:
                      editable ? const Icon(Icons.edit_calendar_rounded) : null,
                  labelText: 'Due Back',
                  border: const OutlineInputBorder(),
                  constraints: const BoxConstraints(maxWidth: 200),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
