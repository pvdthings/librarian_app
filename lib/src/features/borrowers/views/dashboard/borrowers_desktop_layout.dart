import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/borrowers/views/dashboard/borrower_details_pane.dart';
import 'package:librarian_app/src/features/borrowers/views/dashboard/borrowers_list_pane.dart';
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
