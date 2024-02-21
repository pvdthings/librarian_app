import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/actions/widgets/action_wizard_controller.dart';
import 'package:librarian_app/src/features/actions/widgets/extend_all_due_dates/extend_all_due_dates.dart';

class ActionWizard extends StatefulWidget {
  const ActionWizard({
    super.key,
    required this.controller,
  });

  final ActionWizardController controller;

  @override
  State<ActionWizard> createState() => _ActionWizardState();
}

class _ActionWizardState extends State<ActionWizard> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(ExtendAllDueDates.description),
          const SizedBox(height: 32),
          TextFormField(
            controller: widget.controller.dueDateController,
            decoration: const InputDecoration(
              labelText: 'Due Date',
              helperText: 'Click to choose a new date',
              border: OutlineInputBorder(),
            ),
            onTap: () {
              final now = DateTime.now();
              showDatePicker(
                context: context,
                initialDate: now,
                firstDate: now,
                lastDate: now.add(const Duration(days: 14)),
              ).then((value) {
                if (value == null) return;
                widget.controller.dueDate = value;
              });
            },
          )
        ],
      ),
    );
  }
}
