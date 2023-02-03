import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:provider/provider.dart';

import 'thing_list_tile.dart';

class PickThingsView extends StatefulWidget {
  const PickThingsView({
    super.key,
    required this.pickedThings,
    required this.onThingPicked,
  });

  final List<Thing> pickedThings;
  final Function(Thing) onThingPicked;

  @override
  State<StatefulWidget> createState() {
    return _PickThingsViewState();
  }
}

class _PickThingsViewState extends State<PickThingsView> {
  final searchController = TextEditingController();

  void showThingCheckedOutDialog(Thing thing) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thing Unavailable"),
          content: Text("Thing #${thing.id} is checked out."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  void showUnknownThingDialog(String searchValue, int lastNumber) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thing #$searchValue does not exist"),
          content: Text("For demo purposes, try #1 - #$lastNumber."),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final things = Provider.of<ThingsModel>(context).getAll();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchController,
            onSubmitted: (value) {
              final matches = things
                  .where((t) => t.id.toString() == searchController.text)
                  .toList();

              if (matches.length == 1) {
                final match = matches[0];
                if (!match.available) {
                  showThingCheckedOutDialog(match);
                } else {
                  widget.onThingPicked(match);
                }
              }

              if (matches.isEmpty) {
                showUnknownThingDialog(value, things.length);
              }

              searchController.clear();
            },
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: "Enter Thing #",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        ListView.builder(
          itemCount: widget.pickedThings.length,
          itemBuilder: (context, index) {
            final thing = widget.pickedThings[index];

            return ThingListTile(
              id: thing.id,
              name: thing.name,
              available: thing.available,
              selected: true,
              alternateTileColor: index % 2 == 0,
              onTap: () => widget.onThingPicked(thing),
            );
          },
          shrinkWrap: true,
        ),
      ],
    );
  }
}
