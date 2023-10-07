import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_issues.dart';

import '../../data/borrower_model.dart';

class BorrowerDetails extends StatefulWidget {
  final BorrowerModel borrower;

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
    final borrower = widget.borrower;

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
            constraints: BoxConstraints(maxWidth: 500),
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
            constraints: BoxConstraints(maxWidth: 500),
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
            constraints: BoxConstraints(maxWidth: 500),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Issues (${widget.borrower.issues.length})',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        BorrowerIssues(
          borrowerId: borrower.id,
          issues: borrower.issues,
          onRecordCashPayment: _showPaymentSnackBar,
        ),
        if (widget.borrower.active)
          Text(
            'Ready to borrow!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
