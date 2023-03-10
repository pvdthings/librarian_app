import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';

class NeedsAttentionView extends StatelessWidget {
  final Borrower borrower;

  const NeedsAttentionView({super.key, required this.borrower});

  static final _reasonMap = <InactiveReasonCode, Reason>{
    InactiveReasonCode.unpaidDues: const Reason(
      title: "Dues Not Paid",
      explanation:
          "All borrowing members are required to pay annual dues. The QR code below redirects to Givebutter, where the borrower can pay their dues. Cash is accepted.",
      graphicUrl: "qr_givebutter.png",
    ),
    InactiveReasonCode.overdueLoan: const Reason(
      title: "Overdue Loan",
      explanation:
          "This borrower has an overdue loan. They will not be eligible to borrow again until the overdue item(s) are returned.",
    ),
    InactiveReasonCode.banned: const Reason(
      title: "Banned",
      explanation: "This person has been banned from borrowing.",
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: borrower.inactiveReasons!.length,
        itemBuilder: (context, index) {
          final reasonCode = borrower.inactiveReasons![index];
          final reason = _reasonMap[reasonCode]!;

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reason.title,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    reason.explanation ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  if (reason.graphicUrl != null)
                    Center(child: Image.asset(reason.graphicUrl!)),
                ],
              ),
            ),
          );
        },
        shrinkWrap: true,
      ),
    );
  }
}

class Reason {
  final String title;
  final String? explanation;
  final String? graphicUrl;

  const Reason({
    required this.title,
    this.explanation,
    this.graphicUrl,
  });
}
