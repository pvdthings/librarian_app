import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_header.dart';

import '../../models/loan_model.dart';
import 'loan_details.dart';

class LoanDetailsPane extends StatelessWidget {
  final LoanModel? loan;
  final void Function(DateTime dueDate, String? notes) onSave;
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
                LoanDetailsHeader(
                  loan: loan!,
                  onSave: onSave,
                  onCheckIn: onCheckIn,
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
