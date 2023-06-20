import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/borrowers/views/borrowers_view.dart';
import 'package:provider/provider.dart';

import '../data/borrower_model.dart';

class ConnectedBorrowersList extends StatelessWidget {
  final void Function(BorrowerModel)? onTap;
  final String? filter;

  const ConnectedBorrowersList({
    super.key,
    this.onTap,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersViewModel>(
      builder: (context, model, child) {
        return BorrowersView(
          model: model,
          searchFilter: filter ?? '',
          onTap: onTap,
        );
      },
    );
  }
}
