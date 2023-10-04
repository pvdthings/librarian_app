import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/inventory/models/item_model.dart';
import 'package:librarian_app/src/features/loans/data/loans.vm.dart';
import 'package:librarian_app/src/features/loans/widgets/things_list/thing_list_tile.widget.dart';
import 'package:provider/provider.dart';

class ThingsListView extends StatefulWidget {
  const ThingsListView({
    super.key,
    required this.onTapThing,
  });

  final Function(ItemModel) onTapThing;

  @override
  State<ThingsListView> createState() => _ThingsListViewState();
}

class _ThingsListViewState extends State<ThingsListView> {
  final List<String> _selectedThingIds = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansViewModel>(
      builder: (context, model, child) {
        final things = [];

        return ListView.builder(
          itemCount: things.length,
          itemBuilder: (context, index) {
            final thing = things[index];

            return ThingListTile(
              number: thing.id,
              name: thing.name,
              available: thing.available,
              selected: _selectedThingIds.contains(thing.id),
              onTap: thing.available
                  ? () {
                      setState(() {
                        if (_selectedThingIds.contains(thing.id)) {
                          _selectedThingIds.remove(thing.id);
                          return;
                        }

                        _selectedThingIds.add(thing.id);
                      });
                      widget.onTapThing(thing);
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}
