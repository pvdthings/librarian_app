import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/data/loans_model.dart';

import 'checkin_dialog.dart';
import 'loan_details.dart';

class LoanDetailsPane extends StatefulWidget {
  final Loan? loan;
  final void Function(DateTime dueDate) onSave;
  final void Function() onCheckIn;

  const LoanDetailsPane({
    super.key,
    required this.loan,
    required this.onSave,
    required this.onCheckIn,
  });

  @override
  State<LoanDetailsPane> createState() => _LoanDetailsPaneState();
}

class _LoanDetailsPaneState extends State<LoanDetailsPane> {
  bool _editMode = false;
  DateTime? _newDueDate;

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Card(
      margin: const EdgeInsets.all(8),
      child: loan == null
          ? const Center(child: Text('Loan Details'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.loan!.thing.name!,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Chip(label: Text('#${loan.thing.number}'))
                        ],
                      ),
                      Row(
                        children: [
                          if (!_editMode)
                            IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CheckinDialog(
                                      thingNumber: loan.thing.number,
                                      onCheckin: widget.onCheckIn,
                                    );
                                  },
                                );
                              },
                              tooltip: 'Check in',
                              icon: const Icon(Icons.check_circle_rounded),
                            ),
                          if (_editMode && _newDueDate != null)
                            IconButton(
                              onPressed: () {
                                widget.onSave(_newDueDate!);
                                setState(() => _editMode = false);
                              },
                              icon: const Icon(Icons.save_rounded),
                              tooltip: 'Save',
                            ),
                          const SizedBox(width: 4),
                          _editMode
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _newDueDate = null;
                                      _editMode = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                  tooltip: 'Cancel',
                                )
                              : IconButton(
                                  onPressed: () =>
                                      setState(() => _editMode = true),
                                  icon: const Icon(Icons.edit_rounded),
                                  tooltip: 'Edit',
                                ),
                        ],
                      )
                    ],
                  ),
                ),
                LoanDetails(
                  borrower: loan.borrower,
                  things: [loan.thing],
                  checkedOutDate: loan.checkedOutDate,
                  dueDate: _newDueDate ?? loan.dueDate,
                  isOverdue: loan.isOverdue,
                  onDueDateUpdated: (dueDate) {
                    setState(() => _newDueDate = dueDate);
                  },
                  editable: _editMode,
                ),
              ],
            ),
    );
  }
}
