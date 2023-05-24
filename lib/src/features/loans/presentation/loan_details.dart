import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/loans/data/things_model.dart';

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
  final Borrower borrower;
  final List<Thing> things;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final DateTime? checkedInDate;
  final bool isOverdue;

  final Function(DateTime) onDueDateUpdated;

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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: TextEditingController(text: borrower.name),
            enabled: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.person_rounded),
              labelText: 'Borrower',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 32),
          ...things.map((thing) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TextField(
                controller: TextEditingController(
                    text: '${thing.name ?? 'Unknown'} #${thing.number}'),
                enabled: false,
                decoration: const InputDecoration(
                  icon: Icon(Icons.build_rounded),
                  labelText: 'Thing',
                  border: OutlineInputBorder(),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
                text: '${checkedOutDate.month}/${checkedOutDate.day}'),
            enabled: false,
            decoration: const InputDecoration(
              icon: Icon(Icons.calendar_month_rounded),
              labelText: 'Checked Out',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller:
                TextEditingController(text: '${dueDate.month}/${dueDate.day}'),
            enabled: editable,
            onTap: () {
              if (editable) {
                showDateSelection(context);
              }
            },
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_month_rounded),
              iconColor: isOverdue ? Colors.orange : null,
              labelText: 'Due Back',
              border: const OutlineInputBorder(),
            ),
          ),
          if (checkedInDate != null)
            Card(
              child: ListTile(
                leading: const Text("Checked In"),
                title: Text("${checkedInDate!.month}/${checkedInDate!.day}"),
              ),
            ),
        ],
      ),
    );
  }
}
