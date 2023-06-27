import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/search_field.dart';
import 'package:librarian_app/src/features/inventory/views/dashboard/inventory_details_pane.dart';
import 'package:provider/provider.dart';

import '../../data/inventory_view_model.dart';
import '../../widgets/create_thing_dialog.dart';
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SearchField(
                            onChanged: (value) {
                              setState(() => _searchFilter = value);
                            },
                            onClearPressed: () {
                              setState(() => _searchFilter = '');
                              model.clearSelection();
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CreateThingDialog(
                                    onCreate: (name, spanishName) {
                                      model
                                          .createThing(
                                              name: name,
                                              spanishName: spanishName)
                                          .then((value) {
                                        Navigator.of(context).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                Text('${value.name} created'),
                                          ),
                                        );
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.add),
                            tooltip: 'New Thing',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: InventoryView(
                        model: model,
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
