import 'package:flutter/material.dart';
import 'package:librarian_app/models/borrowers_model.dart';

class NeedsAttentionView extends StatelessWidget {
  final Borrower borrower;

  const NeedsAttentionView({super.key, required this.borrower});

  static final _reasonMap = <String, Reason>{
    'duesNotPaid': const Reason(
      title: "Dues Not Paid",
      explanation:
          "Scan the QR code to pay annual dues. \nAlternatively, cash is accepted.",
      graphicUrl: "qr_givebutter.png",
    ),
    'overdueLoan': const Reason(
      title: "Overdue Loan",
      explanation:
          "This borrower has an overdue loan. They will not be eligible to borrow again until the overdue item(s) are returned.",
    ),
    'suspended': const Reason(
      title: "Suspended",
      explanation: "This person has been suspended from borrowing.",
    ),
  };

  @override
  Widget build(BuildContext context) {
    if (borrower.issues.isEmpty) {
      return const Center(child: Text('Ready to borrow!'));
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: borrower.issues.length,
        itemBuilder: (context, index) {
          final reasonCode = borrower.issues[index];
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
