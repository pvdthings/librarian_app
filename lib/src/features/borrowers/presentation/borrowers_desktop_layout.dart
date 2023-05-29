import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_details_pane.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list_view.dart';
import 'package:provider/provider.dart';

class BorrowersDesktopLayout extends StatefulWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  State<BorrowersDesktopLayout> createState() => _BorrowersDesktopLayoutState();
}

class _BorrowersDesktopLayoutState extends State<BorrowersDesktopLayout> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Card(
          margin: const EdgeInsets.all(8),
          child: SizedBox(
            width: 500,
            child: Consumer<BorrowersModel>(
              builder: (context, borrowers, child) {
                return BorrowersListView(
                  onTapBorrower: (b) {
                    borrowers.selectedBorrower = b;
                  },
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Consumer<BorrowersModel>(
            builder: (context, borrowers, child) {
              return BorrowerDetailsPane(borrower: borrowers.selectedBorrower);
            },
          ),
        ),
      ],
    );
  }
}
