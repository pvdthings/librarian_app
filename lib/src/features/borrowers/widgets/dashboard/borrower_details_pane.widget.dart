import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details.widget.dart';
import 'package:librarian_app/src/features/common/widgets/dashboard/pane_header.widget.dart';

import '../../data/borrower.model.dart';

class BorrowerDetailsPane extends StatelessWidget {
  final BorrowerModel? borrower;

  const BorrowerDetailsPane({
    super.key,
    required this.borrower,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: borrower == null
          ? const Center(child: Text('Borrower Details'))
          : Column(
              children: [
                PaneHeader(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            borrower!.name,
                            style: const TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BorrowerDetails(borrower: borrower!),
                ),
              ],
            ),
    );
  }
}
