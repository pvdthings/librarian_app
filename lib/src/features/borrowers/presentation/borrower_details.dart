import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/presentation/dues_dialog.dart';
import 'package:provider/provider.dart';

import '../data/borrowers_model.dart';

class BorrowerDetails extends StatefulWidget {
  final Borrower borrower;

  const BorrowerDetails({
    super.key,
    required this.borrower,
  });

  @override
  State<BorrowerDetails> createState() => _BorrowerDetailsState();
}

class _BorrowerDetailsState extends State<BorrowerDetails> {
  void _showPaymentSnackBar(bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Success!' : 'Failed to record payment'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: widget.borrower.name),
          readOnly: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.person_rounded),
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: widget.borrower.email),
          readOnly: true,
          enabled: widget.borrower.email != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.email_rounded),
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: widget.borrower.phone),
          readOnly: true,
          enabled: widget.borrower.phone != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone_rounded),
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Issues (${widget.borrower.issues.length})',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        ...widget.borrower.issues.map((issue) {
          return ListTile(
            leading: IconButton(
              onPressed: issue.type == IssueType.duesNotPaid
                  ? () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return DuesNotPaidDialog(
                                instructions: issue.instructions!,
                                imageUrl: issue.graphicUrl,
                                onConfirmPayment: (cash) {
                                  Provider.of<BorrowersModel>(
                                    context,
                                    listen: false,
                                  )
                                      .recordCashPayment(
                                          borrowerId: widget.borrower.id,
                                          cash: cash)
                                      .then(_showPaymentSnackBar);
                                });
                          });
                    }
                  : null,
              icon: const Icon(
                Icons.warning_rounded,
                color: Colors.amber,
              ),
              tooltip: issue.instructions != null ? 'More Info' : null,
            ),
            title: Text(issue.title),
            subtitle:
                issue.explanation != null ? Text(issue.explanation!) : null,
          );
        }),
        if (widget.borrower.active)
          Text(
            'Ready to borrow!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
