import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';

import '../data/loan_model.dart';
import 'checkin_dialog.dart';
import 'loan_details.dart';

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
  bool _editMode = false;
  DateTime? _newDueDate;

  void _reset() {
    _editMode = false;
    _newDueDate = null;
  }

  @override
  Widget build(BuildContext context) {
    final loan = widget.loan;

    return Card(
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
                          Text(
                            widget.loan!.thing.name!,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            '#${loan.thing.number}',
                            style: const TextStyle(fontSize: 16),
                          ),
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
                                setState(_reset);
                              },
                              icon: const Icon(Icons.save_rounded),
                              tooltip: 'Save',
                            ),
                          const SizedBox(width: 4),
                          _editMode
                              ? IconButton(
                                  onPressed: () => setState(_reset),
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
                const Divider(),
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
                    editable: _editMode,
                  ),
                ),
              ],
            ),
    );
  }
}
