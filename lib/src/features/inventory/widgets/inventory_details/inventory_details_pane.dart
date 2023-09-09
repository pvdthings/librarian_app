import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/common/widgets/save_dialog.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/inventory/data/detailed_thing.model.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/data/inventory_details.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/inventory_details.dart';
import 'package:provider/provider.dart';

class InventoryDetailsPane extends StatelessWidget {
  const InventoryDetailsPane({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryViewModel>(
      builder: (context, inventory, child) {
        return Card(
          clipBehavior: Clip.antiAlias,
          child: inventory.selectedId == null
              ? const Center(child: Text('Inventory Details'))
              : FutureBuilder<DetailedThingModel>(
                  future: inventory.getThingDetails(id: inventory.selectedId!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final thingDetails = snapshot.data!;

                    final details = InventoryDetailsViewModel(
                      inventory: inventory,
                      thingId: thingDetails.id,
                      name: thingDetails.name,
                      spanishName: thingDetails.spanishName,
                      hidden: thingDetails.hidden,
                      image: thingDetails.images.firstOrNull,
                      items: thingDetails.items,
                      availableItems: thingDetails.available,
                    );

                    return Column(
                      children: [
                        ListenableBuilder(
                          listenable: details,
                          builder: (context, child) {
                            return PaneHeader(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        details.name,
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (details.hasUnsavedChanges) ...[
                                        Text(
                                          'Unsaved Changes',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .copyWith(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                fontStyle: FontStyle.italic,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      IconButton(
                                        onPressed: details.hasUnsavedChanges
                                            ? () async {
                                                if (await showSaveDialog(
                                                    context)) {
                                                  await details.save();
                                                }
                                              }
                                            : null,
                                        icon: const Icon(Icons.save_rounded),
                                        tooltip: 'Save',
                                      ),
                                      const SizedBox(width: 4),
                                      IconButton(
                                        onPressed: details.hasUnsavedChanges
                                            ? details.discardChanges
                                            : null,
                                        icon: const Icon(Icons.cancel),
                                        tooltip: 'Discard Changes',
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: ListenableBuilder(
                                listenable: details,
                                builder: (BuildContext context, Widget? child) {
                                  return InventoryDetails(details: details);
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
      },
    );
  }
}
