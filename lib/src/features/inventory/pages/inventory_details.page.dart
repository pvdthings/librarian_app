import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/inventory.vm.dart';
import '../widgets/inventory_details_view.widget.dart';

class InventoryDetailsPage extends StatelessWidget {
  const InventoryDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final inventory = Provider.of<InventoryViewModel>(context);
    final selected = inventory.selected!;

    final name = TextEditingController(text: selected.name);
    final spanishName = TextEditingController(text: selected.spanishName);

    return Scaffold(
      appBar: AppBar(
        title: Text(selected.name),
        actions: [
          if (!inventory.editing)
            IconButton(
              onPressed: () => inventory.editing = true,
              icon: const Icon(Icons.edit),
            ),
          if (inventory.editing)
            IconButton(
              onPressed: () async {
                await inventory.updateThing(
                  thingId: selected.id,
                  name: name.text,
                  spanishName: spanishName.text,
                );

                inventory.editing = false;
              },
              icon: const Icon(Icons.save),
            ),
          if (inventory.editing)
            IconButton(
              onPressed: () => inventory.editing = false,
              icon: const Icon(Icons.close),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: InventoryDetailsView(
            nameController: name,
            spanishNameController: spanishName,
          ),
        ),
      ),
    );
  }
}
