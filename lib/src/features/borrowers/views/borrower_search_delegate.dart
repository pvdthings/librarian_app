import 'package:flutter/material.dart';

import '../data/borrower_model.dart';
import '../data/borrowers_view_model.dart';
import 'borrowers_view.dart';

class BorrowerSearchDelegate extends SearchDelegate<BorrowerModel?> {
  BorrowerSearchDelegate({required this.model});

  final BorrowersViewModel model;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BorrowersView(
      model: model,
      searchFilter: query,
      onTap: (borrower) => close(context, borrower),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BorrowersView(
      model: model,
      searchFilter: query,
      onTap: (borrower) => close(context, borrower),
    );
  }
}
