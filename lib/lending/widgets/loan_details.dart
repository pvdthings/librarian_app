import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';

class LoanDetails extends StatefulWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.dueDate,
    required this.onDueDateUpdated,
    this.editable = true,
    this.onClose,
  });

  final bool editable;
  final Borrower borrower;
  final List<Thing> things;
  final DateTime dueDate;

  final Function(DateTime) onDueDateUpdated;
  final Function()? onClose;

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
                    .map((t) => Chip(
                          label: Text("#${t.id} - ${t.name}"),
                          backgroundColor: Colors.blue[100],
                        ))
                    .toList(),
              ),
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
          if (widget.editable && widget.onClose != null)
            ElevatedButton(
              onPressed: widget.onClose,
              child: const Text("Check in"),
            )
        ],
      ),
    );
  }
}
