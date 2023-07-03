import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_view_model.dart';

import '../../data/thing_model.dart';
import '../../widgets/inventory_details.dart';

class InventoryDetailsPane extends StatefulWidget {
  final ThingModel? thing;
  final InventoryViewModel model;

  const InventoryDetailsPane({
    super.key,
    required this.thing,
    required this.model,
  });

  @override
  State<InventoryDetailsPane> createState() => _InventoryDetailsPaneState();
}

class _InventoryDetailsPaneState extends State<InventoryDetailsPane> {
  Future<void> _save(String name, String spanishName) async {
    await widget.model.updateThing(
      thingId: widget.thing!.id,
      name: name,
      spanishName: spanishName,
    );
    widget.model.editing = false;
  }

  @override
  Widget build(BuildContext context) {
    final thing = widget.thing;
    final name = TextEditingController(text: thing?.name);
    final spanishName = TextEditingController(text: thing?.spanishName);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: thing == null
          ? const Center(child: Text('Inventory Details'))
          : FutureBuilder<DetailedThingModel>(
              future: widget.model.getThingDetails(id: thing.id),
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

                return Column(
                  children: [
                    PaneHeader(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                thingDetails!.name,
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
                            ) {
                              widget.model
                                  .createItems(
                                    thingId: thing.id,
                                    quantity: quantity,
                                    brand: brand,
                                    description: description,
                                    estimatedValue: estimatedValue,
                                  )
                                  .then((_) => Navigator.of(context).pop());
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
