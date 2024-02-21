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
      dueDateController.text = formatDateForHumans(value);
    }

    notifyListeners();
  }

  final dueDateController = TextEditingController();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> Function()? get onExecute =>
      _dueDate != null && !isLoading ? _runAction : null;

  Future<void> _runAction() {
    isLoading = true;
    return service.extendAllDueDates(dueDate!).then((success) {
      Future.delayed(Duration(seconds: success ? 5 : 0), () {
        Navigator.of(context).pop(success);

        if (success) {
          final dateString = formatDateForHumans(dueDate!);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('All due dates were updated to $dateString')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                SizedBox(width: 8),
                Text('Whoops! Due dates could not be extended.'),
              ],
            ),
          ));
        }
      });
    });
  }
}
