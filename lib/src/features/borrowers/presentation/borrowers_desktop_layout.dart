import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_details_pane.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.dart';
import 'package:provider/provider.dart';

class BorrowersDesktopLayout extends StatefulWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  State<BorrowersDesktopLayout> createState() => _BorrowersDesktopLayoutState();
}

class _BorrowersDesktopLayoutState extends State<BorrowersDesktopLayout> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersViewModel>(
      builder: (context, borrowers, child) {
        return Row(
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 500,
                child: Consumer<BorrowersViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        PaneHeader(
                          child: SearchField(
                            onChanged: (value) {
                              setState(() => _searchFilter = value);
                            },
                            onClearPressed: () {
                              setState(() => _searchFilter = '');
                              model.clearSelectedBorrower();
                            },
                          ),
                        ),
                        BorrowersList(
                          borrowers: model.filtered(_searchFilter),
                          selected: model.selectedBorrower,
                          onTap: (borrower) {
                            model.selectedBorrower = borrower;
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: BorrowerDetailsPane(borrower: borrowers.selectedBorrower),
            ),
          ],
        );
      },
    );
  }
}
