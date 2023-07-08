import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.dart';
import 'package:librarian_app/src/features/inventory/views/dashboard/inventory_details_pane.dart';
import 'package:provider/provider.dart';

import '../../data/inventory_view_model.dart';
import '../inventory_view.dart';

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
        Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: 500,
            child: Consumer<InventoryViewModel>(
              builder: (context, model, child) {
                return Column(
                  children: [
                    PaneHeader(
                      child: SearchField(
                        onChanged: (value) {
                          setState(() => _searchFilter = value);
                        },
                        onClearPressed: () {
                          setState(() => _searchFilter = '');
                          model.clearSelection();
                        },
                      ),
                    ),
                    Expanded(
                      child: InventoryView(
                        searchFilter: _searchFilter,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Expanded(
          child: Consumer<InventoryViewModel>(
            builder: (context, inventory, child) {
              return InventoryDetailsPane(
                thing: inventory.selected,
                model: inventory,
              );
            },
          ),
        ),
      ],
    );
  }
}
