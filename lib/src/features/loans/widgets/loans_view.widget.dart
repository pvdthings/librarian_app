import 'package:flutter/material.dart';

import '../data/loan.model.dart';
import '../data/loans.vm.dart';
import '../widgets/loans_list.widget.dart';

class LoansView extends StatelessWidget {
  const LoansView({
    super.key,
    required this.model,
    required this.searchFilter,
    this.onTap,
  });

  final LoansViewModel model;
  final String searchFilter;
  final void Function(LoanModel)? onTap;

  @override
  Widget build(BuildContext context) {
    if (model.errorMessage != null) {
      return Center(child: Text(model.errorMessage!));
    }

    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final loans = model.filtered(searchFilter);

    if (loans.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return LoansList(
      loans: loans,
      selected: model.selectedLoan,
      onTap: (loan) {
        model.selectedLoan = loan;
        onTap?.call(loan);
      },
    );
  }
}
