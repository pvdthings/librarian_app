import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/data/inventory.vm.dart';
import 'package:librarian_app/src/features/inventory/widgets/inventory_details.widget.dart';
import 'package:provider/provider.dart';

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

            final details = snapshot.data!;

            return InventoryDetails(
              nameController: nameController,
              spanishNameController: spanishNameController,
              items: details.items,
              availableItems: details.available,
              readOnly: !inventory.editing,
              onAddItems: (
                brand,
                description,
                estimatedValue,
                quantity,
              ) async {
                await inventory.createItems(
                  thingId: details.id,
                  quantity: quantity,
                  brand: brand,
                  description: description,
                  estimatedValue: estimatedValue,
                );
              },
            );
          },
        );
      },
    );
  }
}
