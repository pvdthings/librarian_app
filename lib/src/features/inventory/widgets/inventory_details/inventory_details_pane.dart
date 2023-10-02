import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/common/widgets/save_dialog.widget.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';
import 'package:librarian_app/src/features/inventory/models/detailed_thing_model.dart';
import 'package:librarian_app/src/features/inventory/providers/selected_thing_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/inventory_details_view_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details/inventory_details.dart';

class InventoryDetailsPane extends ConsumerWidget {
  const InventoryDetailsPane({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedThing = ref.watch(selectedThingProvider);
    final thingDetails = ref.watch(thingDetailsProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: selectedThing == null
          ? const Center(child: Text('Inventory Details'))
          : FutureBuilder<DetailedThingModel?>(
              future: thingDetails,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }

                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final thingDetails = snapshot.data!;

                final details = InventoryDetailsViewModel(
                  inventory: ref.read(thingsRepositoryProvider),
                  thingId: thingDetails.id,
                  name: thingDetails.name,
                  spanishName: thingDetails.spanishName,
                  hidden: thingDetails.hidden,
                  images: thingDetails.images,
                  items: thingDetails.items,
                  availableItems: thingDetails.available,
                  onSave: () => ref.invalidate(thingsRepositoryProvider),
                );

                return Column(
                  children: [
                    ListenableBuilder(
                      listenable: details,
                      builder: (context, child) {
                        return PaneHeader(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontStyle: FontStyle.italic,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  IconButton(
                                    onPressed: details.hasUnsavedChanges
                                        ? () async {
                                            if (await showSaveDialog(context)) {
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
  }
}
