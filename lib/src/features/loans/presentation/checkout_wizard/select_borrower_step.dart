import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/presentation/searchable_borrowers_list.dart';
import 'package:librarian_app/src/features/borrowers/presentation/needs_attention_view.dart';
import 'package:librarian_app/src/features/loans/data/wizard_model.dart';
import 'package:provider/provider.dart';

class SelectBorrowerStep extends StatelessWidget {
  const SelectBorrowerStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'Select a borrower.',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Card(
              child: Consumer<WizardModel>(
                builder: (context, value, child) {
                  if (value.borrower != null && !value.borrower!.active) {
                    return NeedsAttentionView(borrower: value.borrower!);
                  }

                  return SearchableBorrowersList(
                    onTapBorrower: (b) {
                      value.selectBorrower(b, stepForward: b.active);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
