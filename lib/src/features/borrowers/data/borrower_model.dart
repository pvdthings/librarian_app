class BorrowerModel {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final List<Issue> issues;

  bool get active => issues.isEmpty;

  BorrowerModel({
    required this.id,
    required this.name,
    required this.issues,
    this.email,
    this.phone,
  });
}

class Issue {
  final IssueType type;
  final String title;
  final String? explanation;
  final String? instructions;
  final String? graphicUrl;

  const Issue({
    required this.title,
    this.explanation,
    this.instructions,
    this.graphicUrl,
    required this.type,
  });
}

enum IssueType {
  duesNotPaid,
  overdueLoan,
  suspended,
  needsLiabilityWaiver,
}
