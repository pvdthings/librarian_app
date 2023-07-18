import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';

import '../../data/loan.model.dart';
import '../checkin/checkin_dialog.widget.dart';
import 'loan_details.widget.dart';
import 'thing_number.widget.dart';

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
                          if (_editMode && _newDueDate != null) ...[
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
                            IconButton(
                              onPressed: () {
                                widget.onSave(_newDueDate!);
                                setState(_reset);
                              },
                              icon: const Icon(Icons.save_rounded),
                              tooltip: 'Save',
                            ),
                          ],
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
                    editable: _editMode,
                  ),
                ),
              ],
            ),
    );
  }
}
