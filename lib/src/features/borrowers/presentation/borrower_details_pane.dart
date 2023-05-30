import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_details.dart';

import '../data/borrowers_model.dart';

class BorrowerDetailsPane extends StatefulWidget {
  final Borrower? borrower;

  const BorrowerDetailsPane({
    super.key,
    required this.borrower,
  });

  @override
  State<BorrowerDetailsPane> createState() => _BorrowerDetailsPaneState();
}

class _BorrowerDetailsPaneState extends State<BorrowerDetailsPane> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: widget.borrower == null
          ? const Center(child: Text('Borrower Details'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.borrower!.name,
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
                  child: BorrowerDetails(borrower: widget.borrower!),
                ),
              ],
            ),
    );
  }
}
