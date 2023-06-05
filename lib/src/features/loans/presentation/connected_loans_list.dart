import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/presentation/loans_list.dart';
import 'package:provider/provider.dart';

import '../data/loans_view_model.dart';

class ConnectedLoansList extends StatelessWidget {
  final void Function(LoanModel loan)? onTap;
  final String? filter;

  const ConnectedLoansList({
    super.key,
    this.onTap,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansViewModel>(
      builder: (context, model, child) {
        if (model.errorMessage != null) {
          return Center(child: Text(model.errorMessage!));
        }

        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var localLoans = model.loans;

        if (localLoans.isNotEmpty && filter != null && filter!.isNotEmpty) {
          localLoans = localLoans.where((loan) {
            final borrowerName = loan.borrower.name.toLowerCase();
            final filterText = filter!.toLowerCase();
            return borrowerName.contains(filterText);
          }).toList();
        }

        return LoansList(
          loans: localLoans,
          selected: model.selectedLoan,
          onTap: (l) {
            model.selectedLoan = l;
            onTap?.call(l);
          },
        );
      },
    );
  }
}
