import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';

import '../../models/loan_model.dart';
import '../checkin/checkin_dialog.dart';
import '../edit/edit_loan_dialog.dart';
import 'loan_details.dart';
import 'thing_number.dart';

class LoanDetailsPane extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                          ThingNumber(number: loan!.thing.number),
                          const SizedBox(width: 16),
                          Text(
                            loan!.thing.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return EditLoanDialog(
                                    dueDate: loan!.dueDate,
                                    onSavePressed: (newDueDate) {
                                      onSave(newDueDate);
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
                                    thingNumber: loan!.thing.number,
                                    onCheckin: () async {
                                      await Future(onCheckIn);
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
                    borrower: loan!.borrower,
                    things: [loan!.thing],
                    notes: loan!.notes,
                    checkedOutDate: loan!.checkedOutDate,
                    dueDate: loan!.dueDate,
                    isOverdue: loan!.isOverdue,
                  ),
                ),
              ],
            ),
    );
  }
}
