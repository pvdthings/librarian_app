import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/presentation/connected_borrowers_list.dart';

import '../data/borrower_model.dart';

class BorrowerSearchDelegate extends SearchDelegate<BorrowerModel?> {
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
    return ConnectedBorrowersList(
      filter: query,
      onTap: (borrower) => close(context, borrower),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ConnectedBorrowersList(
      filter: query,
      onTap: (borrower) => close(context, borrower),
    );
  }
}
