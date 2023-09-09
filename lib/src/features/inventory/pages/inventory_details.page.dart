import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/inventory.vm.dart';
import '../widgets/inventory_details/data/inventory_details.vm.dart';
import '../widgets/inventory_details/inventory_details.dart';

class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryViewModel>(context);

    return FutureBuilder(
      future: inventory.getThingDetails(id: inventory.selectedId!),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorScaffold(snapshot.error.toString());
        }

        if (!snapshot.hasData) {
          return loadingScaffold;
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
