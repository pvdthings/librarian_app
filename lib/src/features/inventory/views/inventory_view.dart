import 'package:flutter/material.dart';

import '../data/inventory_view_model.dart';
import '../data/thing_model.dart';
import '../widgets/inventory_list.dart';

class InventoryView extends StatelessWidget {
  const InventoryView({
    super.key,
    required this.model,
    required this.searchFilter,
    this.onTap,
  });

  final InventoryViewModel model;
  final String searchFilter;
  final void Function(ThingModel)? onTap;

  @override
  Widget build(BuildContext context) {
    final things = model.filtered(searchFilter);

    if (things.isEmpty) {
      return const Center(child: Text('No results found'));
    }

    return InventoryList(
      things: things,
      selected: model.selected,
      onTap: (thing) {
        model.select(thing);
        onTap?.call(thing);
      },
    );
  }
}
