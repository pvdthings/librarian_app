import 'package:flutter/material.dart';

class NeedsAttentionView extends StatelessWidget {
  const NeedsAttentionView({super.key});

  static final reasons = [
    const Reason(
      title: "Dues Not Paid",
      explanation:
          "All borrowing members are required to pay annual dues. The QR code below redirects to Givebutter, where the borrower can pay their dues. Cash is accepted.",
      graphicUrl: "qr_givebutter.png",
    ),
    const Reason(
      title: "Overdue Loan",
      explanation:
          "This borrower has an overdue loan. They will not be eligible to borrow again until the overdue item(s) are returned.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        itemCount: reasons.length,
        itemBuilder: (context, index) {
          final reason = reasons[index];

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
                  if (reason.graphicUrl != null)
                    Image.asset(reason.graphicUrl!),
                ],
              ),
            ),
          );
        },
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
