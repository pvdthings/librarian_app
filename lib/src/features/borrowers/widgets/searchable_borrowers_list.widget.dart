import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrower.model.dart';
import 'package:librarian_app/src/features/borrowers/widgets/connected_borrowers_list.widget.dart';

import '../../common/widgets/submit_text_field.widget.dart';

class SearchableBorrowersList extends StatefulWidget {
  final void Function(BorrowerModel borrower)? onTapBorrower;

  const SearchableBorrowersList({
    super.key,
    this.onTapBorrower,
  });

  @override
  State<SearchableBorrowersList> createState() =>
      _SearchableBorrowersListState();
}

class _SearchableBorrowersListState extends State<SearchableBorrowersList> {
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
