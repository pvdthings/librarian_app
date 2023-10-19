import 'package:flutter/material.dart';

import '../models/borrower_model.dart';
import 'borrowers_list/borrowers_list_view.dart';

class BorrowerSearchDelegate extends SearchDelegate<BorrowerModel?> {
  BorrowerSearchDelegate();

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
      onTap: (borrower) => close(context, borrower),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BorrowersView(
      onTap: (borrower) => close(context, borrower),
    );
  }
}
