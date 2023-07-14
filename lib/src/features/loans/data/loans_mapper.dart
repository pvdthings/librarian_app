import 'package:librarian_app/src/features/loans/data/thing_summary.model.dart';

import '../../borrowers/data/borrower.model.dart';
import 'loan.model.dart';

class LoansMapper {
  static Iterable<LoanModel> map(Iterable<dynamic> data) {
    return data.map((e) => LoanModel(
          id: e['id'] as String? ?? '?',
          thing: ThingSummaryModel.fromJson(e['thing'] as Map<String, dynamic>),
          borrower: BorrowerModel(
            id: e['borrower']?['id'] as String? ?? '?',
            name: e['borrower']?['name'] as String? ?? '???',
            issues: [],
          ),
          checkedOutDate: e['checkedOutDate'] != null
              ? DateTime.parse(e['checkedOutDate'] as String)
              : DateTime.now(),
          checkedInDate: e['checkedInDate'] != null
              ? DateTime.parse(e['checkedInDate'] as String)
              : null,
          dueDate: e['dueBackDate'] != null
              ? DateTime.parse(e['dueBackDate'])
              : DateTime.now(),
        ));
  }
}
