import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrowers_view.widget.dart';
import 'package:provider/provider.dart';

import '../data/borrower.model.dart';

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
