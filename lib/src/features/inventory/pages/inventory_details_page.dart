import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:librarian_app/src/features/inventory/providers/thing_details_provider.dart';

import '../providers/edited_thing_details_providers.dart';
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
        final hasUnsavedChanges = ref.watch(unsavedChangesProvider);

        return Scaffold(
          appBar: AppBar(
            title: Text(thingDetails.name),
            actions: [
              IconButton(
                onPressed: hasUnsavedChanges
                    ? ref.read(thingDetailsEditorProvider).save
                    : null,
                icon: const Icon(Icons.save),
              ),
              IconButton(
                onPressed: hasUnsavedChanges
                    ? ref.read(thingDetailsEditorProvider).discardChanges
                    : null,
                icon: const Icon(Icons.cancel),
              ),
            ],
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: InventoryDetails(),
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
