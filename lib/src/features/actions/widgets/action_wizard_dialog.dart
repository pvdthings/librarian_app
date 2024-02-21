import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard_controller.dart';
import 'package:librarian_app/src/features/actions/widgets/extend_all_due_dates/extend_all_due_dates.dart';

class ActionWizardDialog extends StatelessWidget {
  const ActionWizardDialog({
    super.key,
    required this.controller,
  });

  final ActionWizardController controller;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.33,
      heightFactor: 0.66,
      child: AlertDialog(
        icon: const Icon(
          Icons.electric_bolt_rounded,
          color: Colors.amber,
        ),
        title: const Text(ExtendAllDueDates.title),
        content: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ActionWizard(controller: controller),
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          ListenableBuilder(
            listenable: controller,
            builder: (context, child) {
              return FilledButton.icon(
                onPressed: controller.onExecute,
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Run Action'),
              );
            },
          ),
        ],
      ),
    );
  }
}
