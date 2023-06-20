import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';

import '../presentation/borrowers_list.dart';

class BorrowersView extends StatelessWidget {
  const BorrowersView({
    super.key,
    required this.model,
    required this.searchFilter,
  });

  final BorrowersViewModel model;
  final String searchFilter;

  @override
  Widget build(BuildContext context) {
    if (model.errorMessage != null) {
      return Center(child: Text(model.errorMessage!));
    }

    if (model.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final borrowers = model.filtered(searchFilter);

    if (borrowers.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return BorrowersList(
      borrowers: model.filtered(searchFilter),
      selected: model.selectedBorrower,
      onTap: (borrower) {
        model.selectedBorrower = borrower;
      },
    );
  }
}
