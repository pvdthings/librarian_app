import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.dart';

import '../../data/inventory_view_model.dart';
import '../../widgets/inventory_details.dart';

class InventoryDetailsPane extends StatefulWidget {
  final ThingModel? thing;

  const InventoryDetailsPane({
    super.key,
    required this.thing,
  });

  @override
  State<InventoryDetailsPane> createState() => _InventoryDetailsPaneState();
}

class _InventoryDetailsPaneState extends State<InventoryDetailsPane> {
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
          : Column(
              children: [
                PaneHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            thing.name,
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
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: InventoryDetails(),
                ),
              ],
            ),
    );
  }
}
