import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/filled_progress_button.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';

import '../../models/loan_model.dart';
import '../checkin/checkin_dialog.dart';
import 'loan_details.dart';
import 'thing_number.dart';

class LoanDetailsPane extends StatefulWidget {
  final LoanModel? loan;
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
  DateTime? _newDueDate;

  void _reset() {
    _newDueDate = null;
  }

  bool _hasUnsavedChanges() {
    return _newDueDate != null;
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: loan == null
          ? const Center(child: Text('Loan Details'))
          : Column(
              children: [
                PaneHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ThingNumber(number: loan.thing.number),
                          const SizedBox(width: 16),
                          Text(
                            widget.loan!.thing.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (_hasUnsavedChanges()) ...[
                            Text(
                              'Unsaved Changes',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return _EditLoanDialog(
                                    dueDate: loan.dueDate,
                                    isOverdue: false,
                                    onSavePressed: (newDueDate) {
                                      widget.onSave(newDueDate);
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                          ),
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: VerticalDivider(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CheckinDialog(
                                    thingNumber: loan.thing.number,
                                    onCheckin: () async {
                                      _reset();
                                      await Future(widget.onCheckIn);
                                    },
                                  );
                                },
                              );
                            },
                            tooltip: 'Check in',
                            icon: const Icon(Icons.library_add_check),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: LoanDetails(
                    borrower: loan.borrower,
                    things: [loan.thing],
                    checkedOutDate: loan.checkedOutDate,
                    dueDate: _newDueDate ?? loan.dueDate,
                    isOverdue: loan.isOverdue,
                    onDueDateUpdated: (dueDate) {
                      setState(() => _newDueDate = dueDate);
                    },
                    editable: true,
                  ),
                ),
              ],
            ),
    );
  }
}

class _EditLoanDialog extends StatefulWidget {
  const _EditLoanDialog({
    required this.dueDate,
    required this.isOverdue,
    required this.onSavePressed,
  });

  final DateTime dueDate;
  final bool isOverdue;
  final void Function(DateTime newDueDate) onSavePressed;

  @override
  State<_EditLoanDialog> createState() => _EditLoanDialogState();
}

class _EditLoanDialogState extends State<_EditLoanDialog> {
  late DateTime dueDate = widget.dueDate;

  bool _hasUnsavedChanges() => dueDate != widget.dueDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledProgressButton(
          onPressed: _hasUnsavedChanges()
              ? () {
                  widget.onSavePressed(dueDate);
                  Navigator.of(context).pop(true);
                }
              : null,
          child: const Text('Save'),
        ),
      ],
      icon: const Icon(Icons.edit),
      title: const Text('Edit Loan'),
      content: TextField(
        controller: TextEditingController(
          text: '${dueDate.month}/${dueDate.day}',
        ),
        onTap: () {
          showDatePicker(
            context: context,
            initialDate: dueDate,
            firstDate: widget.dueDate,
            lastDate: widget.dueDate.add(const Duration(days: 14)),
          ).then((value) {
            if (value == null) return;
            setState(() => dueDate = value);
          });
        },
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_month_rounded),
          iconColor: widget.isOverdue ? Colors.orange : null,
          labelText: 'Due Back',
          border: const OutlineInputBorder(),
          constraints: const BoxConstraints(maxWidth: 200),
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}
