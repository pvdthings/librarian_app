import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:provider/provider.dart';

import 'submit_text_field.dart';
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
  final _searchController = TextEditingController();

  void _onSearchSubmitted(List<Thing> things, String value) {
    final matches =
        things.where((t) => t.id.toString() == _searchController.text).toList();

    if (matches.length == 1) {
      final match = matches[0];
      if (!match.available) {
        _showThingCheckedOutDialog(match);
      } else {
        widget.onThingPicked(match);
      }
    }

    if (matches.isEmpty) {
      _showUnknownThingDialog(value, things.length);
    }

    _searchController.clear();
  }

  void _showThingCheckedOutDialog(Thing thing) {
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

  void _showUnknownThingDialog(String searchValue, int lastNumber) {
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

    final pickedThings = widget.pickedThings;
    pickedThings.sort((a, b) => a.id.compareTo(b.id));

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            labelText: "Thing ID",
            prefixIcon: const Icon(Icons.search),
            controller: _searchController,
            onSubmitted: (value) => _onSearchSubmitted(things, value),
            onChanged: (_) => {},
          ),
        ),
        ListView.builder(
          itemCount: pickedThings.length,
          itemBuilder: (context, index) {
            final thing = pickedThings[index];

            return ThingListTile(
              id: thing.id,
              name: thing.name,
              available: thing.available,
              selected: true,
              onTap: () => widget.onThingPicked(thing),
            );
          },
          shrinkWrap: true,
        ),
      ],
    );
  }
}
