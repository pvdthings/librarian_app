import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/borrowers/providers/borrowers_repository_provider.dart';

import '../../models/issue_model.dart';
import '../dialogs/dues_dialog.dart';

class BorrowerIssues extends ConsumerWidget {
  final String borrowerId;
  final List<Issue> issues;
  final void Function(bool success) onRecordCashPayment;

  const BorrowerIssues({
    super.key,
    required this.borrowerId,
    required this.issues,
    required this.onRecordCashPayment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: issues.length,
      itemBuilder: (context, index) {
        final issue = issues[index];

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
                                ref
                                    .read(borrowersRepositoryProvider.notifier)
                                    .recordCashPayment(
                                        borrowerId: borrowerId, cash: cash)
                                    .then(onRecordCashPayment);
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
          subtitle: issue.explanation != null ? Text(issue.explanation!) : null,
        );
      },
      shrinkWrap: true,
    );
  }
}
