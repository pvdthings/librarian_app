import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/common/widgets/input_decoration.dart';
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
                                    context,
                                    onCreate: (name, spanishName) {},
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

class CreateThingDialog extends StatelessWidget {
  CreateThingDialog(this.parentContext, {super.key, this.onCreate});

  final BuildContext parentContext;
  final void Function(String name, String? spanishName)? onCreate;

  final _name = TextEditingController();
  final _spanishName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.close),
                ),
              ),
            ),
            TextField(
              controller: _name,
              decoration: inputDecoration.copyWith(labelText: 'Name'),
            ),
            TextField(
              controller: _spanishName,
              decoration: inputDecoration.copyWith(labelText: 'Name (Spanish)'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                FilledButton(
                  onPressed: () {},
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
