import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.widget.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';

import '../borrowers_view.widget.dart';

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
