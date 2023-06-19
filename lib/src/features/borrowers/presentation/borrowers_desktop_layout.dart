import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_details_pane.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrowers_list.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:provider/provider.dart';

class BorrowersDesktopLayout extends StatefulWidget {
  const BorrowersDesktopLayout({super.key});

  @override
  State<BorrowersDesktopLayout> createState() => _BorrowersDesktopLayoutState();
}

class _BorrowersDesktopLayoutState extends State<BorrowersDesktopLayout> {
  final _searchController = TextEditingController();
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersViewModel>(
      builder: (context, borrowers, child) {
        return Row(
          children: [
            Card(
              child: SizedBox(
                width: 500,
                child: Consumer<BorrowersViewModel>(
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        PaneHeader(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() => _searchFilter = value);
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search...',
                              icon: Icon(
                                Icons.search_rounded,
                                color: _searchFilter.isEmpty
                                    ? null
                                    : Theme.of(context).primaryIconTheme.color,
                              ),
                              suffixIcon: _searchFilter.isEmpty
                                  ? null
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchFilter = '';
                                        });
                                        model.clearSelectedBorrower();
                                      },
                                      icon: const Icon(Icons.clear_rounded),
                                      tooltip: 'Clear Search',
                                    ),
                            ),
                          ),
                        ),
                        const Divider(),
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
