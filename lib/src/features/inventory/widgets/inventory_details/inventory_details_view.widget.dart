import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:provider/provider.dart';

import 'data/inventory_details.vm.dart';
import 'new_inventory_details.dart';

class InventoryDetailsView extends StatelessWidget {
  const InventoryDetailsView({
    super.key,
    required this.nameController,
    required this.spanishNameController,
  });

  final TextEditingController nameController;
  final TextEditingController spanishNameController;

  @override
  Widget build(BuildContext context) {
    return Consumer<InventoryViewModel>(
      builder: (context, inventory, child) {
        return FutureBuilder(
          future: inventory.getThingDetails(id: inventory.selectedId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error!.toString()));
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
              items: thingDetails.items,
              availableItems: thingDetails.available,
            );

            return InventoryDetails(details: details);
          },
        );
      },
    );
  }
}
