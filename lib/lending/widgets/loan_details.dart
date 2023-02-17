import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    required this.onDueDateUpdated,
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

  final Function(DateTime) onDueDateUpdated;
  final Function(int)? onClose;

  @override
  State<LoanDetails> createState() => _LoanDetailsState();
}

class _LoanDetailsState extends State<LoanDetails> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Text("Borrower"),
              title: Text(widget.borrower.name),
            ),
          ),
          Card(
            child: ListTile(
              leading: Text(widget.things.length > 1 ? "Things" : "Thing"),
              title: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: widget.things
                    .map((t) => Chip(label: Text("#${t.id} - ${t.name}")))
                    .toList(),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text("Checked Out"),
              title: Text(
                  "${widget.checkedOutDate!.month}/${widget.checkedOutDate!.day}"),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Text("Due Date"),
              title: Text("${widget.dueDate.month}/${widget.dueDate.day}"),
              trailing: widget.editable ? const Icon(Icons.edit_rounded) : null,
              onTap: widget.editable
                  ? () async {
                      showDatePicker(
                        context: context,
                        initialDate: widget.dueDate,
                        firstDate: widget.dueDate,
                        lastDate: widget.dueDate.add(const Duration(days: 14)),
                      ).then((value) {
                        if (value == null) return;
                        widget.onDueDateUpdated(value);
                      });
                    }
                  : null,
            ),
          ),
          if (widget.checkedInDate != null)
            Card(
              child: ListTile(
                leading: const Text("Checked In"),
                title: Text(
                    "${widget.checkedInDate!.month}/${widget.checkedInDate!.day}"),
              ),
            ),
          if (widget.editable && widget.onClose != null)
            OutlinedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    final thingId = widget.things[0].id;
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
                            widget.onClose!(thingId);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text("Check in"),
            )
        ],
      ),
    );
  }
}
