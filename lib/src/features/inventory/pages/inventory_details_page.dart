import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';
import 'package:librarian_app/src/features/inventory/providers/things_repository_provider.dart';

import '../widgets/inventory_details/inventory_details_view_model.dart';
import '../widgets/inventory_details/inventory_details.dart';

class InventoryDetailsPage extends ConsumerWidget {
  const InventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thingDetails = ref.watch(thingDetailsProvider);

    return FutureBuilder(
      future: thingDetails,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorScaffold(snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return loadingScaffold;
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

        return Scaffold(
          appBar: AppBar(
            title: Text(details.name),
            actions: [
              ListenableBuilder(
                listenable: details,
                builder: (context, child) {
                  return IconButton(
                    onPressed: details.hasUnsavedChanges ? details.save : null,
                    icon: const Icon(Icons.save),
                  );
                },
              ),
              ListenableBuilder(
                listenable: details,
                builder: (context, child) {
                  return IconButton(
                    onPressed: details.hasUnsavedChanges
                        ? details.discardChanges
                        : null,
                    icon: const Icon(Icons.cancel),
                  );
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListenableBuilder(
                listenable: details,
                builder: (context, child) => InventoryDetails(details: details),
              ),
            ),
          ),
        );
      },
    );
  }
}

Scaffold errorScaffold(String error) {
  return Scaffold(
    body: Center(
      child: Text(error),
    ),
  );
}

const loadingScaffold = Scaffold(
  body: Center(
    child: CircularProgressIndicator(),
  ),
);
