import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/models/borrower_model.dart';
import 'package:librarian_app/src/features/common/widgets/detail.dart';
import 'package:librarian_app/src/features/loans/models/thing_summary_model.dart';
import 'package:librarian_app/src/utils/media_query.dart';

class LoanDetails extends StatelessWidget {
  const LoanDetails({
    super.key,
    required this.borrower,
    required this.things,
    required this.checkedOutDate,
    required this.dueDate,
    this.isOverdue = false,
    this.notes,
  });

  final BorrowerModel? borrower;
  final List<ThingSummaryModel> things;
  final String? notes;
  final DateTime checkedOutDate;
  final DateTime dueDate;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(builder: (context) {
            final children = [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Detail(
                    prefixIcon: const Icon(Icons.person),
                    label: 'Borrower',
                    value: borrower!.name,
                  ),
                  const SizedBox(height: 16),
                  Detail(
                    prefixIcon: const Icon(Icons.email),
                    label: 'Borrower Email',
                    placeholderText: 'None',
                    value: borrower!.email,
                  ),
                  const SizedBox(height: 16),
                  Detail(
                    prefixIcon: const Icon(Icons.phone),
                    label: 'Borrower Phone',
                    placeholderText: 'None',
                    value: borrower!.phone,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...things.map((thing) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Detail(
                        prefixIcon: const Icon(Icons.build_rounded),
                        label: 'Thing',
                        value: '#${thing.number} ${thing.name}',
                      ),
                    );
                  })
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Detail(
                    prefixIcon: const Icon(Icons.calendar_month),
                    label: 'Checked Out',
                    value:
                        '${checkedOutDate.month}/${checkedOutDate.day}/${checkedOutDate.year}',
                  ),
                  const SizedBox(height: 16),
                  Detail(
                    prefixIcon: Builder(
                      builder: (_) {
                        if (!isOverdue) {
                          return const Icon(Icons.calendar_month);
                        }

                        return const Tooltip(
                          message: 'Overdue',
                          child: Icon(
                            Icons.calendar_month,
                            color: Colors.amber,
                          ),
                        );
                      },
                    ),
                    label: 'Due Back',
                    value: '${dueDate.month}/${dueDate.day}/${dueDate.year}',
                  ),
                ],
              ),
            ];

            if (isMobile(context)) {
              return ListView.separated(
                itemCount: children.length,
                itemBuilder: (context, index) {
                  return children[index];
                },
                separatorBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: const Divider(),
                  );
                },
                shrinkWrap: true,
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            );
          }),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: const Divider(),
          ),
          Detail(
            label: 'Notes',
            minWidth: 500,
            placeholderText: 'None',
            value: notes,
          ),
        ],
      ),
    );
  }
}
