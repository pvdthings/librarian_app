import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/loans/providers/loan_details_provider.dart';
import 'package:librarian_app/src/features/loans/providers/loans_filter_provider.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_pane.dart';
import 'package:librarian_app/src/features/loans/widgets/loans_list/loans_list_view.dart';

class LoansDesktopLayout extends ConsumerWidget {
  const LoansDesktopLayout({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        ListPane(
          header: PaneHeader(
            child: SearchField(
              text: ref.watch(loansFilterProvider),
              onChanged: (value) {
                ref.read(loansFilterProvider.notifier).state =
                    value.toLowerCase();
              },
              onClearPressed: () {
                ref.read(loansFilterProvider.notifier).state = null;
                ref.read(selectedLoanProvider.notifier).state = null;
              },
            ),
          ),
          child: const LoansListView(),
        ),
        Expanded(
          child: FutureBuilder(
            future: ref.watch(loanDetailsProvider),
            builder: (context, snapshot) {
              return LoanDetailsPane(
                loan: snapshot.data,
                onSave: (newDueDate, notes) {
                  final selectedLoan = ref.read(selectedLoanProvider)!;
                  ref.read(loansRepositoryProvider.notifier).updateLoan(
                      loanId: selectedLoan.id,
                      thingId: selectedLoan.thing.id,
                      dueBackDate: newDueDate,
                      notes: notes);
                },
                onCheckIn: () {
                  final selectedLoan = ref.read(selectedLoanProvider)!;
                  ref
                      .read(loansRepositoryProvider.notifier)
                      .closeLoan(
                        loanId: selectedLoan.id,
                        thingId: selectedLoan.thing.id,
                      )
                      .then((_) {
                    ref.read(selectedLoanProvider.notifier).state = null;
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
