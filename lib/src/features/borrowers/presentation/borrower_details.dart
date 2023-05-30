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
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: borrower.email),
          readOnly: true,
          enabled: borrower.email != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.person_rounded),
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: borrower.phone),
          readOnly: true,
          enabled: borrower.phone != null,
          decoration: const InputDecoration(
            icon: Icon(Icons.person_rounded),
            labelText: 'Phone',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Issues (${borrower.issues.length})',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
        ...borrower.issues.map((issue) {
          return ListTile(
            leading: IconButton(
              onPressed: issue.instructions != null
                  ? () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(issue.title),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    issue.instructions!,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (issue.graphicUrl != null)
                                    Center(
                                      child: Image.asset(
                                        issue.graphicUrl!,
                                        width: 500,
                                      ),
                                    ),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
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
        if (borrower.active)
          Text(
            'Ready to borrow!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
