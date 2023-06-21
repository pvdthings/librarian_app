import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.dart';

import '../borrowers_view.dart';

class BorrowersListPane extends StatefulWidget {
  const BorrowersListPane({super.key, required this.model});

  final BorrowersViewModel model;

  @override
  State<BorrowersListPane> createState() => _BorrowersListPaneState();
}

class _BorrowersListPaneState extends State<BorrowersListPane> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: 500,
        child: Column(
          children: [
            PaneHeader(
              child: SearchField(
                onChanged: (value) {
                  setState(() => _searchFilter = value);
                },
                onClearPressed: () {
                  setState(() => _searchFilter = '');
                  widget.model.clearSelectedBorrower();
                },
              ),
            ),
            Expanded(
              child: BorrowersView(
                model: widget.model,
                searchFilter: _searchFilter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
