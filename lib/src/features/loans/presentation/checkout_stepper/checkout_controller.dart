import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/loans/data/loans_view_model.dart';
import 'package:provider/provider.dart';

class CheckoutController {
  final dateFormat = DateFormat('yyyy-MM-dd');
  late LoansViewModel _model;

  CheckoutController(BuildContext context) {
    _model = Provider.of<LoansViewModel>(context, listen: false);
  }

  Future<void> checkOut({
    required String borrowerId,
    required List<String> thingIds,
    required DateTime dueBackDate,
  }) async {
    await _model.openLoan(
      borrowerId: borrowerId,
      thingIds: thingIds,
      checkedOutDate: dateFormat.format(DateTime.now()),
      dueBackDate: dateFormat.format(dueBackDate),
    );
  }
}
