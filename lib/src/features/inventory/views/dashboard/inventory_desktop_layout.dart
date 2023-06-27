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
                                    onCreate: (name, spanishName) {
                                      model
                                          .createThing(
                                            name: name,
                                            spanishName: spanishName,
                                          )
                                          .then((value) =>
                                              Navigator.of(context).pop());
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

class CreateThingDialog extends StatelessWidget {
  CreateThingDialog({super.key, this.onCreate});

  final void Function(String name, String? spanishName)? onCreate;

  final _name = TextEditingController();
  final _spanishName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'New Thing',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _name,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name',
                  icon: const Icon(Icons.build),
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _spanishName,
                decoration: inputDecoration.copyWith(
                  labelText: 'Name (Spanish)',
                  icon: const Icon(Icons.build),
                  constraints: const BoxConstraints(minWidth: 500),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: () {
                      onCreate?.call(_name.text, _spanishName.text);
                    },
                    child: const Text('Create'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
