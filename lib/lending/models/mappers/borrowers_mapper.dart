import '../borrowers_model.dart';

class BorrowersMapper {
  static Iterable<Borrower> map(Iterable<dynamic> data) {
    // TODO: map contact info
    return data
        .map((e) => Borrower(
              id: e['id'] as String? ?? '???',
              name: e['name'] as String? ?? '???',
              issues:
                  (e['issues'] as List? ?? []).map((e) => e as String).toList(),
            ))
        .toList();
  }
}
