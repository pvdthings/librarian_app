import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/inventory_view_model.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details.dart';
import 'package:provider/provider.dart';

class InventoryDetailsView extends StatelessWidget {
  const InventoryDetailsView({super.key});

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

            final details = snapshot.data!;

            return InventoryDetails(
              nameController: TextEditingController(text: details.name),
              spanishNameController:
                  TextEditingController(text: details.spanishName),
              items: details.items,
              availableItems: details.available,
            );
          },
        );
      },
    );
  }
}
