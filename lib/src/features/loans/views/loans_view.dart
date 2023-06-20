import 'package:flutter/material.dart';

import '../data/loans_view_model.dart';
import '../presentation/loans_list.dart';

class LoansView extends StatelessWidget {
  const LoansView({
    super.key,
    required this.model,
    required this.searchFilter,
  });

  final LoansViewModel model;
  final String searchFilter;

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
      onTap: (loan) => model.selectedLoan = loan,
    );
  }
}
