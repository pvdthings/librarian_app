import 'package:flutter/material.dart';

import '../data/borrowers_model.dart';

class BorrowerDetails extends StatelessWidget {
  final Borrower borrower;

  const BorrowerDetails({
    super.key,
    required this.borrower,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: TextEditingController(text: borrower.name),
          readOnly: true,
          decoration: const InputDecoration(
            icon: Icon(Icons.person_rounded),
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        ...borrower.issues.map((issue) {
          return ListTile(
            title: Text(issue.title),
            subtitle:
                issue.explanation != null ? Text(issue.explanation!) : null,
          );
        }),
      ],
    );
  }
}
