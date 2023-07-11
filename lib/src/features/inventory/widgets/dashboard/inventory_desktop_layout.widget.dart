import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.widget.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.widget.dart';
import 'package:librarian_app/src/features/inventory/widgets/dashboard/inventory_details_pane.widget.dart';
import 'package:provider/provider.dart';

import '../../data/inventory.vm.dart';
import '../inventory_view.widget.dart';

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
