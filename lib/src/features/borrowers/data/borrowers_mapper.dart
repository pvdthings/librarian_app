import 'borrower.model.dart';

class BorrowersMapper {
  static Iterable<BorrowerModel> map(Iterable<dynamic> data) {
    return data
        .map((e) => BorrowerModel(
              id: e['id'] as String? ?? '???',
              name: e['name'] as String? ?? '???',
              email: e['contact']?['email'] as String?,
              phone: e['contact']?['phone'] as String?,
              issues: (e['issues'] as List? ?? [])
                  .map((e) => _reasonMap[e as String]!)
                  .toList(),
            ))
        .toList();
  }

  static final _reasonMap = <String, Issue>{
    'duesNotPaid': const Issue(
      title: "Dues Not Paid",
      explanation: "Annual dues must be paid before borrowing.",
      instructions:
          "The borrower can pay their dues from the library's website or by scanning the QR code.",
      graphicUrl: "qr_givebutter.png",
      type: IssueType.duesNotPaid,
    ),
    'overdueLoan': const Issue(
      title: "Overdue Loan",
      explanation:
          "All overdue items must be returned before they can borrow again.",
      type: IssueType.overdueLoan,
    ),
    'suspended': const Issue(
      title: "Suspended",
      explanation: "This person has been suspended from borrowing.",
      type: IssueType.suspended,
    ),
    'needsLiabilityWaiver': const Issue(
      title: "Needs Liability Waiver",
      explanation:
          "This borrower needs to sign our library's liability waiver before they can check anything out.",
      type: IssueType.needsLiabilityWaiver,
    ),
  };
}
