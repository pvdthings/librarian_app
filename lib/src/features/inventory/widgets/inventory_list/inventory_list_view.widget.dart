import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/inventory.vm.dart';
import '../../data/thing.model.dart';
import 'inventory_list.widget.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({
    super.key,
    required this.searchFilter,
    this.onTap,
  });

  final String searchFilter;
  final void Function(ThingModel)? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryViewModel>(
      builder: (context, model, child) {
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
      },
    );
  }
}
