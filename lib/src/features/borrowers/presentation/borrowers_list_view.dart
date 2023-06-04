import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/connected_borrowers_list.dart';

import '../../common/presentation/submit_text_field.dart';

class BorrowersListView extends StatefulWidget {
  final void Function(Borrower borrower)? onTapBorrower;

  const BorrowersListView({
    super.key,
    this.onTapBorrower,
  });

  @override
  State<BorrowersListView> createState() => _BorrowersListViewState();
}

class _BorrowersListViewState extends State<BorrowersListView> {
  final _searchController = TextEditingController();
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            hintText: "Alice Appleseed",
            labelText: "Search",
            prefixIcon: const Icon(Icons.search),
            showSubmitButton: false,
            onChanged: (value) {
              setState(() => _searchText = value.toLowerCase());
            },
            onSubmitted: (_) => {},
            controller: _searchController,
          ),
        ),
        Expanded(
          child: ConnectedBorrowersList(
            onTap: widget.onTapBorrower,
            filter: _searchText,
          ),
        ),
      ],
    );
  }
}
