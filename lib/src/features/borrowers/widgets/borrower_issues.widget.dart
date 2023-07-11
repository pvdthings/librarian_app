import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/borrower.model.dart';
import '../data/borrowers.vm.dart';
import '../widgets/dues_dialog.widget.dart';

class BorrowerIssues extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                                Provider.of<BorrowersViewModel>(
                                  context,
                                  listen: false,
                                )
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
