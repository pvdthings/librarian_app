import 'package:flutter/material.dart';
import 'package:librarian_app/models/things_model.dart';
import 'package:librarian_app/widgets/thing_list_tile.dart';
import 'package:provider/provider.dart';

class ThingsListView extends StatefulWidget {
  const ThingsListView({
    super.key,
    required this.onTapThing,
  });

  final Function(Thing) onTapThing;

  @override
  State<ThingsListView> createState() => _ThingsListViewState();
}

class _ThingsListViewState extends State<ThingsListView> {
  final List<String> _selectedThingIds = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThingsModel>(
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
