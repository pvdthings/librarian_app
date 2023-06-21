import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/views/loans_view.dart';
import 'package:provider/provider.dart';

import '../data/loan_model.dart';
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
        return LoansView(
          model: model,
          searchFilter: filter ?? '',
          onTap: onTap,
        );
      },
    );
  }
}
