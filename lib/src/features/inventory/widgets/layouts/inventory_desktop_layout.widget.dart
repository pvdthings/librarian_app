import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/list_pane.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:provider/provider.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import '../inventory_details/inventory_details_pane.widget.dart';

import '../../data/inventory.vm.dart';
import '../inventory_list/inventory_list_view.widget.dart';

class InventoryDesktopLayout extends StatefulWidget {
  const InventoryDesktopLayout({super.key});

  @override
  State<InventoryDesktopLayout> createState() => _InventoryDesktopLayoutState();
}

class _InventoryDesktopLayoutState extends State<InventoryDesktopLayout> {
  String _searchFilter = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Consumer<InventoryViewModel>(
          builder: (context, inventory, child) {
            return ListPane(
              header: PaneHeader(
                child: SearchField(
                  onChanged: (value) {
                    setState(() => _searchFilter = value);
                  },
                  onClearPressed: () {
                    setState(() => _searchFilter = '');
                    inventory.clearSelection();
                  },
                ),
              ),
              child: InventoryListView(searchFilter: _searchFilter),
            );
          },
        ),
        Expanded(
          child: Consumer<InventoryViewModel>(
            builder: (context, inventory, child) {
              return InventoryDetailsPane(
                thingId: inventory.selected?.id,
                model: inventory,
              );
            },
          ),
        ),
      ],
    );
  }
}
