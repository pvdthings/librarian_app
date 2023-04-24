import 'package:flutter/material.dart';
import 'package:librarian_app/lending/widgets/loans_list_view.dart';
import 'package:librarian_app/lending/widgets/submit_text_field.dart';

class SearchableLoansList extends StatefulWidget {
  const SearchableLoansList({super.key});

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
        Expanded(child: LoansListView(filter: _searchText)),
      ],
    );
  }
}
