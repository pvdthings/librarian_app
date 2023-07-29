import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/submit_text_field.widget.dart';
import 'package:librarian_app/src/features/inventory/data/thing.model.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_list/inventory_list_view.widget.dart';

class SearchableInventoryList extends StatefulWidget {
  final Function(ThingModel)? onThingTapped;

  const SearchableInventoryList({
    super.key,
    this.onThingTapped,
  });

  @override
  State<StatefulWidget> createState() {
    return _SearchableInventoryListState();
  }
}

class _SearchableInventoryListState extends State<SearchableInventoryList> {
  final _searchController = TextEditingController();
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            hintText: "Hammer",
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
          child: InventoryListView(
            searchFilter: _searchText,
            onTap: widget.onThingTapped,
          ),
        ),
      ],
    );
  }
}
