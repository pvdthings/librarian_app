import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/issues_card.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/payments_card.dart';

import '../../models/borrower_model.dart';

class BorrowerDetails extends StatelessWidget {
  final BorrowerModel borrower;

  const BorrowerDetails({
    super.key,
    required this.borrower,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: borrower.name),
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
          controller: TextEditingController(text: borrower.email),
          readOnly: true,
          enabled: borrower.email != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.email_rounded),
            labelText: 'Email',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 500),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: borrower.phone),
          readOnly: true,
          enabled: borrower.phone != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.phone_rounded),
            labelText: 'Phone',
            border: OutlineInputBorder(),
            constraints: BoxConstraints(maxWidth: 500),
          ),
        ),
        const SizedBox(height: 32),
        const IssuesCard(),
        const SizedBox(height: 32),
        const PaymentsCard(),
      ],
    );
  }
}
