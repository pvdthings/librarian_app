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
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: widget.borrower == null
          ? const Center(child: Text('Borrower Details'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
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
                      Row(
                        children: [
                          if (_editMode)
                            IconButton(
                              onPressed: () {
                                setState(() => _editMode = false);
                              },
                              icon: const Icon(Icons.save_rounded),
                              tooltip: 'Save',
                            ),
                          const SizedBox(width: 4),
                          _editMode
                              ? IconButton(
                                  onPressed: () {
                                    setState(() => _editMode = false);
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                  tooltip: 'Cancel',
                                )
                              : IconButton(
                                  onPressed: () =>
                                      setState(() => _editMode = true),
                                  icon: const Icon(Icons.edit_rounded),
                                  tooltip: 'Edit',
                                ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BorrowerDetails(borrower: widget.borrower!),
                ),
              ],
            ),
    );
  }
}
