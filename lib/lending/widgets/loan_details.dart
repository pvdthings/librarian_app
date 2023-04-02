import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';

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
    this.onClose,
  });

  final bool editable;
  final Borrower borrower;
  final List<Thing> things;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final DateTime? checkedInDate;
  final bool isOverdue;

  final Function(DateTime) onDueDateUpdated;
  final Function(String)? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Text("Borrower"),
              title: Text(borrower.name),
            ),
          ),
          Card(
            child: ListTile(
              leading: Text(things.length > 1 ? "Things" : "Thing"),
              title: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: things
                    .map((t) => Chip(
                        label: Text("#${t.number}  ${t.name ?? 'Unknown'}")))
                    .toList(),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text("Checked Out"),
              title: Text("${checkedOutDate.month}/${checkedOutDate.day}"),
            ),
          ),
          Card(
            child: ListTile(
              leading: isOverdue
                  ? const Text(
                      "Overdue",
                      style: TextStyle(color: Colors.orange),
                    )
                  : const Text("Due Date"),
              title: Text("${dueDate.month}/${dueDate.day}"),
              trailing: editable ? const Icon(Icons.edit_rounded) : null,
              onTap: editable
                  ? () async {
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
                  : null,
            ),
          ),
          if (checkedInDate != null)
            Card(
              child: ListTile(
                leading: const Text("Checked In"),
                title: Text("${checkedInDate!.month}/${checkedInDate!.day}"),
              ),
            ),
          const SizedBox(height: 16),
          if (editable && onClose != null)
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final thingId = things[0].number;
                    return AlertDialog(
                      title: Text("Thing #$thingId"),
                      content: Text(
                          "Are you sure you want to check Thing #$thingId back in?"),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            Navigator.pop(context);
                            onClose!(things[0].id);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.check_box_rounded),
              label: const Text("Check in"),
            ),
        ],
      ),
    );
  }
}
