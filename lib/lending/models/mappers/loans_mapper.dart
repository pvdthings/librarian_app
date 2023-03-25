import '../borrowers_model.dart';
import '../loans_model.dart';
import '../things_model.dart';

class LoansMapper {
  static Iterable<Loan> map(Iterable<dynamic> data) {
    return data.map((e) => Loan(
          thing: Thing(
            name: e['thing']['name'] as String,
            id: e['thing']['id'] as String,
            number: e['thing']['number'] as int,
          ),
          borrower: Borrower(
            name: e['borrower']['name'] as String,
            issues: [],
          ),
          checkedOutDate: DateTime.parse(e['checkedOutDate'] as String),
          checkedInDate: e['checkedInDate'] != null
              ? DateTime.parse(e['checkedInDate'] as String)
              : null,
          dueDate: DateTime.parse(e['dueBackDate']),
        ));
  }
}
