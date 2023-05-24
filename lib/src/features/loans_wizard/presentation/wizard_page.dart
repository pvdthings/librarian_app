import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans_wizard/data/wizard_model.dart';
import 'package:librarian_app/src/features/loans_wizard/presentation/add_things_step.dart';
import 'package:librarian_app/src/features/loans_wizard/presentation/confirm_details_step.dart';
import 'package:provider/provider.dart';

import 'select_borrower_step.dart';

class WizardPage extends StatefulWidget {
  const WizardPage({super.key});

  @override
  State<WizardPage> createState() => _WizardPageState();
}

class _WizardPageState extends State<WizardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.close_rounded),
          tooltip: 'Cancel',
        ),
        title: const Text('New Loan'),
      ),
      body: ChangeNotifierProvider(
        create: (c) => WizardModel(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<WizardModel>(
            builder: (context, value, child) {
              if (value.step == 0) {
                return const SelectBorrowerStep();
              }

              if (value.step == 1) {
                return const AddThingsStep();
              }

              return const ConfirmDetailsStep();
            },
          ),
        ),
      ),
    );
  }
}
