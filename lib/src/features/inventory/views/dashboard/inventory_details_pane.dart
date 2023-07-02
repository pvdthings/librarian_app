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
  DetailedThingModel? details;
  bool _editMode = false;

  void _reset() {
    _editMode = false;
  }

  @override
  Widget build(BuildContext context) {
    final thing = widget.thing;

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
                              if (_editMode)
                                IconButton(
                                  onPressed: () {
                                    setState(_reset);
                                  },
                                  icon: const Icon(Icons.save_rounded),
                                  tooltip: 'Save',
                                ),
                              const SizedBox(width: 4),
                              _editMode
                                  ? IconButton(
                                      onPressed: () => setState(_reset),
                                      icon: const Icon(Icons.close_rounded),
                                      tooltip: 'Cancel',
                                    )
                                  : IconButton(
                                      onPressed: () =>
                                          setState(() => _editMode = true),
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
                            details: thingDetails,
                            onAddItems:
                                (brand, description, estimatedValue, quantity) {
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
