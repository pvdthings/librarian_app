import 'borrowers_model.dart';

class BorrowersMapper {
  static Iterable<Borrower> map(Iterable<dynamic> data) {
    // TODO: map contact info
    return data
        .map((e) => Borrower(
              id: e['id'] as String? ?? '???',
              name: e['name'] as String? ?? '???',
              issues: (e['issues'] as List? ?? [])
                  .map((e) => _reasonMap[e as String]!)
                  .toList(),
            ))
        .toList();
  }

  static final _reasonMap = <String, Issue>{
    'duesNotPaid': const Issue(
      title: "Dues Not Paid",
      explanation:
          "Scan the QR code to pay annual dues. \nAlternatively, cash is accepted.",
      graphicUrl: "qr_givebutter.png",
    ),
    'overdueLoan': const Issue(
      title: "Overdue Loan",
      explanation:
          "This borrower has an overdue loan. They will not be eligible to borrow again until the overdue item(s) are returned.",
    ),
    'suspended': const Issue(
      title: "Suspended",
      explanation: "This person has been suspended from borrowing.",
    ),
    'needsLiabilityWaiver': const Issue(
      title: "Needs Liability Waiver",
      explanation:
          "This borrower needs to sign our library's liability waiver before they can check anything out.",
    ),
  };
}
