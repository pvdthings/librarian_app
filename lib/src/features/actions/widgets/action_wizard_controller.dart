import 'package:flutter/material.dart';
import 'package:librarian_app/src/utils/format.dart';

import '../providers/actions_service_provider.dart';

class ActionWizardController extends ChangeNotifier {
  ActionWizardController(this.context, {required this.service});

  final BuildContext context;
  final ActionsService service;

  DateTime? _dueDate;

  DateTime? get dueDate => _dueDate;

  set dueDate(DateTime? value) {
    _dueDate = value;

    if (value != null) {
      dueDateController.text = '${_dueDate!.month}/${_dueDate!.day}';
    }

    notifyListeners();
  }

  final dueDateController = TextEditingController();

  void Function()? get onExecute => _dueDate != null ? _runAction : null;

  void _runAction() {
    service.extendAllDueDates(dueDate!).then((value) {
      Navigator.of(context).pop(value);

      if (value) {
        final dateString = formatDateForHumans(dueDate!);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('All due dates were updated to $dateString')));
      }
    });
  }
}
