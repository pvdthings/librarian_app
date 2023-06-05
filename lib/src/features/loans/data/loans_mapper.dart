import '../../borrowers/data/borrowers_view_model.dart';
import 'loans_view_model.dart';
import 'things_model.dart';

class LoansMapper {
  static Iterable<LoanModel> map(Iterable<dynamic> data) {
    return data.map((e) => LoanModel(
          id: e['id'] as String? ?? '?',
          thing: Thing(
            name: e['thing']?['name'] as String? ?? '???',
            id: e['thing']?['id'] as String? ?? '???',
            number: e['thing']?['number'] as int? ?? 0,
          ),
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
