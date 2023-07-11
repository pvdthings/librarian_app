import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/submit_text_field.widget.dart';
import 'package:librarian_app/src/features/loans/data/loan.model.dart';
import 'package:librarian_app/src/features/loans/widgets/connected_loans_list.widget.dart';

class SearchableLoansList extends StatefulWidget {
  final Function(LoanModel)? onLoanTapped;

  const SearchableLoansList({
    super.key,
    this.onLoanTapped,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchableLoansListState();
  }
}

class _SearchableLoansListState extends State<SearchableLoansList> {
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
          child: ConnectedLoansList(
            filter: _searchText,
            onTap: widget.onLoanTapped,
          ),
        ),
      ],
    );
  }
}
