import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/data/things_model.dart';
import 'package:librarian_app/src/features/loans/presentation/pick_things_view.dart';
import 'package:librarian_app/src/features/loans/data/wizard_model.dart';
import 'package:provider/provider.dart';

class AddThingsStep extends StatefulWidget {
  const AddThingsStep({super.key});

  @override
  State<AddThingsStep> createState() => _AddThingsStepState();
}

class _AddThingsStepState extends State<AddThingsStep> {
  final List<Thing> _chosenThings = [];

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<WizardModel>(context, listen: false);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 8, bottom: 16),
          child: Text(
            'Add things to lend.',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                constraints: const BoxConstraints(maxWidth: 540),
                child: Card(
                  child: PickThingsView(
                    pickedThings: _chosenThings,
                    onThingPicked: (t) {
                      setState(() {
                        if (_chosenThings.contains(t)) {
                          _chosenThings.remove(t);
                        } else {
                          _chosenThings.add(t);
                        }
                      });
                    },
                  ),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: _chosenThings.isNotEmpty
                    ? () => model.selectThings(_chosenThings)
                    : null,
                icon: const Icon(Icons.navigate_next),
                label: const Text('Next'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
