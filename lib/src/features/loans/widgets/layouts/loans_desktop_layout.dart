import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/loans/providers/loans_filter_provider.dart';
import 'package:librarian_app/src/features/loans/providers/loans_repository_provider.dart';
import 'package:librarian_app/src/features/loans/providers/selected_loan_provider.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details_pane.widget.dart';
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
          child: LoanDetailsPane(
            loan: ref.watch(selectedLoanProvider),
            onSave: (newDueDate) {
              final selectedLoan = ref.read(selectedLoanProvider)!;
              ref.read(loansRepositoryProvider).updateDueDate(
                    loanId: selectedLoan.id,
                    thingId: selectedLoan.thing.id,
                    dueBackDate: newDueDate,
                  );
            },
            onCheckIn: () {
              final selectedLoan = ref.read(selectedLoanProvider)!;
              ref
                  .read(loansRepositoryProvider)
                  .closeLoan(
                    loanId: selectedLoan.id,
                    thingId: selectedLoan.thing.id,
                  )
                  .then((_) {
                ref.read(selectedLoanProvider.notifier).state = null;
              });
            },
          ),
        ),
      ],
    );
  }
}
