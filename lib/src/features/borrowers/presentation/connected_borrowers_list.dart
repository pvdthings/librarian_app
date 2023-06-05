import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list.dart';
import 'package:provider/provider.dart';

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
        if (model.errorMessage != null) {
          return Center(child: Text(model.errorMessage!));
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
          onTap: (b) {
            model.selectedBorrower = b;
            onTap?.call(b);
          },
          selected: onTap == null ? model.selectedBorrower : null,
        );
      },
    );
  }
}
