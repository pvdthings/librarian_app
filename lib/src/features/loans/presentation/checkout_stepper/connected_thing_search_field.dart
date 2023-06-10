import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/data/thing_model.dart';
import 'package:librarian_app/src/features/loans/data/things_view_model.dart';
import 'package:provider/provider.dart';

class ConnectedThingSearchField extends StatelessWidget {
  final _textController = TextEditingController();

  final ThingSearchController controller;

  bool get isLoading => controller.isLoading;

  ConnectedThingSearchField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      onSubmitted: (value) {
        controller.search(value);
        _textController.clear();
      },
      decoration: const InputDecoration(
        hintText: 'Enter Thing #',
        prefixText: '#',
        prefixIcon: Icon(Icons.build_rounded),
      ),
    );
  }
}

class ThingSearchController {
  final BuildContext context;
  final void Function(ThingModel) onMatchFound;

  bool isLoading = false;

  ThingSearchController({
    required this.context,
    required this.onMatchFound,
  });

  Future<void> search(String value) async {
    isLoading = true;

    final thingsModel = Provider.of<ThingsViewModel>(context, listen: false);
    final match = await thingsModel.getOne(number: int.parse(value));

    isLoading = false;

    if (match != null) {
      if (!match.available) {
        _showThingCheckedOutDialog(match);
      } else {
        onMatchFound(match);
      }
    } else {
      _showUnknownThingDialog(value);
    }
  }

  void _showThingCheckedOutDialog(ThingModel thing) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Thing Unavailable"),
          content: Text("Thing #${thing.number} is checked out."),
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

  void _showUnknownThingDialog(String searchValue) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thing #$searchValue does not exist"),
          content: const Text("Try another number."),
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
}
