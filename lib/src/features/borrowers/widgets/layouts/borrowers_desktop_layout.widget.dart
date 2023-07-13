import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_details_pane.widget.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:provider/provider.dart';

import '../borrowers_list/borrowers_view.widget.dart';

class BorrowersDesktopLayout extends StatefulWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  State<BorrowersDesktopLayout> createState() => _BorrowersDesktopLayoutState();
}

class _BorrowersDesktopLayoutState extends State<BorrowersDesktopLayout> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<BorrowersViewModel>(
          builder: (context, borrowers, child) {
            return ListPane(
              header: PaneHeader(
                child: SearchField(
                  onChanged: (value) {
                    setState(() => _searchFilter = value);
                  },
                  onClearPressed: () {
                    setState(() => _searchFilter = '');
                    borrowers.clearSelectedBorrower();
                  },
                ),
              ),
              child: BorrowersView(
                model: borrowers,
                searchFilter: _searchFilter,
              ),
            );
          },
        ),
        Expanded(
          child: Consumer<BorrowersViewModel>(
            builder: (context, borrowers, child) {
              return BorrowerDetailsPane(
                borrower: borrowers.selectedBorrower,
              );
            },
          ),
        ),
      ],
    );
  }
}
