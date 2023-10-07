import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrower_details/borrower_details.dart';
import 'package:librarian_app/src/features/dashboard/widgets/panes/pane_header.widget.dart';

import '../../data/borrower_model.dart';

class BorrowerDetailsPane extends StatelessWidget {
  final Future<BorrowerModel?> borrowerFuture;

  const BorrowerDetailsPane({
    super.key,
    required this.borrowerFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder(
        future: borrowerFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error!.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final borrower = snapshot.data;

          return borrower == null
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
                                borrower.name,
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
                      child: BorrowerDetails(borrower: borrower),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
