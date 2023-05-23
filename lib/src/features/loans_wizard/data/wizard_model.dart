import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_model.dart';
import 'package:librarian_app/src/features/loans/data/things_model.dart';

class WizardModel extends ChangeNotifier {
  int step = 0;
  Borrower? borrower;
  List<Thing> things = [];
  DateTime dueDate = DateTime.now().add(const Duration(days: 7));

  void selectBorrower(Borrower borrower) {
    this.borrower = borrower;
    step++;
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
