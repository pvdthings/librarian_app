import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/loans/data/things_model.dart';

class WizardModel extends ChangeNotifier {
  int step = 0;
  BorrowerModel? borrower;
  List<Thing> things = [];
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));

  void selectBorrower(BorrowerModel borrower, {bool stepForward = true}) {
    this.borrower = borrower;
    if (stepForward) {
      step++;
    }

    notifyListeners();
  }

  void selectThings(Iterable<Thing> things) {
    this.things.addAll(things);
    step++;
    notifyListeners();
  }

  void updateDueDate(DateTime dueDate) {
    this.dueDate = dueDate;
    notifyListeners();
  }
}
