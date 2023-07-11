import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';
import 'package:librarian_app/src/features/borrowers/widgets/dashboard/borrower_details_pane.widget.dart';
import 'package:librarian_app/src/features/borrowers/widgets/dashboard/borrowers_list_pane.widget.dart';
import 'package:provider/provider.dart';

class BorrowersDesktopLayout extends StatelessWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersViewModel>(
      builder: (context, borrowers, child) {
        return Row(
          children: [
            BorrowersListPane(model: borrowers),
            Expanded(
              child: BorrowerDetailsPane(
                borrower: borrowers.selectedBorrower,
              ),
            ),
          ],
        );
      },
    );
  }
}
