import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:provider/provider.dart';

class ThingsListView extends StatefulWidget {
  const ThingsListView({super.key});

  @override
  State<ThingsListView> createState() => _ThingsListViewState();
}

class _ThingsListViewState extends State<ThingsListView> {
  final List<int> _selectedThingIds = [];

  @override
  Widget build(BuildContext context) {
    return Consumer<ThingsModel>(
      builder: (context, model, child) {
        final things = model.getAll();

        return ListView.builder(
          itemCount: things.length,
          itemBuilder: (context, index) {
            final thing = things[index];

            return ListTile(
              title: Text(thing.name),
              subtitle: thing.available
                  ? const Text(
                      "Available",
                      style: TextStyle(color: Colors.green),
                    )
                  : const Text(
                      "Checked out",
                      style: TextStyle(color: Colors.orange),
                    ),
              leading: Text("#${thing.id}"),
              trailing: _selectedThingIds.contains(thing.id)
                  ? const Icon(Icons.check_rounded, color: Colors.green)
                  : null,
              tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
              hoverColor: Colors.grey[100],
              onTap: thing.available
                  ? () => setState(() {
                        if (_selectedThingIds.contains(thing.id)) {
                          _selectedThingIds.remove(thing.id);
                          return;
                        }

                        _selectedThingIds.add(thing.id);
                      })
                  : null,
            );
          },
        );
      },
    );
  }
}
