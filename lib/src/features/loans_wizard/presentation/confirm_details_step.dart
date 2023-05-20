import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans_wizard/data/wizard_model.dart';
import 'package:provider/provider.dart';

class ConfirmDetailsStep extends StatefulWidget {
  const ConfirmDetailsStep({super.key});

  @override
  State<ConfirmDetailsStep> createState() => _ConfirmDetailsStepState();
}

class _ConfirmDetailsStepState extends State<ConfirmDetailsStep> {
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
            'Confirm details.',
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
                child: const Card(
                  child: Center(child: Text('Loan Details')),
                ),
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  model.confirmLoan();
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Confirm'),
                backgroundColor: Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
