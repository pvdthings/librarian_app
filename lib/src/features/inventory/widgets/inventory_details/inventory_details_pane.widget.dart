import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing.model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';

import 'inventory_details.widget.dart';

class InventoryDetailsPane extends StatefulWidget {
  final String? thingId;
  final InventoryViewModel model;

  const InventoryDetailsPane({
    super.key,
    required this.thingId,
    required this.model,
  });

  @override
  State<InventoryDetailsPane> createState() => _InventoryDetailsPaneState();
}

class _InventoryDetailsPaneState extends State<InventoryDetailsPane> {
  Future<void> _save(String name, String spanishName) async {
    await widget.model.updateThing(
      thingId: widget.thingId!,
      name: name,
      spanishName: spanishName,
    );
    widget.model.editing = false;
  }

  @override
  Widget build(BuildContext context) {
    final thing = widget.thingId;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: thing == null
          ? const Center(child: Text('Inventory Details'))
          : FutureBuilder<DetailedThingModel>(
              future: widget.model.getThingDetails(id: thing),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final thingDetails = snapshot.data;

                final name = TextEditingController(text: thingDetails!.name);
                final spanishName =
                    TextEditingController(text: thingDetails.spanishName);

                return Column(
                  children: [
                    PaneHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                thingDetails.name,
                                style: const TextStyle(fontSize: 24),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              if (widget.model.editing)
                                IconButton(
                                  onPressed: () async => await _save(
                                    name.text,
                                    spanishName.text,
                                  ),
                                  icon: const Icon(Icons.save_rounded),
                                  tooltip: 'Save',
                                ),
                              const SizedBox(width: 4),
                              widget.model.editing
                                  ? IconButton(
                                      onPressed: () =>
                                          widget.model.editing = false,
                                      icon: const Icon(Icons.close_rounded),
                                      tooltip: 'Cancel',
                                    )
                                  : IconButton(
                                      onPressed: () =>
                                          widget.model.editing = true,
                                      icon: const Icon(Icons.edit_rounded),
                                      tooltip: 'Edit',
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: InventoryDetails(
                            readOnly: !widget.model.editing,
                            nameController: name,
                            spanishNameController: spanishName,
                            items: thingDetails.items,
                            availableItems: thingDetails.available,
                            onAddItems: (
                              brand,
                              description,
                              estimatedValue,
                              quantity,
                            ) async {
                              await widget.model.createItems(
                                thingId: thing,
                                quantity: quantity,
                                brand: brand,
                                description: description,
                                estimatedValue: estimatedValue,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
