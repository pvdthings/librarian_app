import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list.dart';
import 'package:provider/provider.dart';

class ConnectedBorrowersList extends StatelessWidget {
  final bool selectOnTap;
  final String? filter;

  const ConnectedBorrowersList({
    super.key,
    this.selectOnTap = false,
    this.filter,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersModel>(
      builder: (context, model, child) {
        if (model.refreshErrorMessage != null) {
          return Center(child: Text(model.refreshErrorMessage!));
        }

        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var localBorrowers = model.borrowers;
        if (filter != null) {
          localBorrowers = localBorrowers
              .where((b) => b.name.toLowerCase().contains(filter!))
              .toList();
        }

        return BorrowersList(
          borrowers: localBorrowers,
          onTap: selectOnTap
              ? (borrower) => model.selectedBorrower = borrower
              : null,
          selected: selectOnTap ? model.selectedBorrower : null,
        );
      },
    );
  }
}
