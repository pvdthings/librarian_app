import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:provider/provider.dart';

class BorrowersListView extends StatelessWidget {
  const BorrowersListView({
    super.key,
    required this.onTapBorrower,
  });

  final void Function(Borrower borrower) onTapBorrower;

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersModel>(
      builder: (context, model, child) {
        final borrowers = model.all.toList();

        return ListView.builder(
          itemCount: borrowers.length,
          itemBuilder: (context, index) {
            final b = borrowers[index];

            return ListTile(
              title: Text(b.name),
              subtitle: b.active
                  ? const Text(
                      "Active",
                      style: TextStyle(
                        color: Colors.green,
                      ),
                    )
                  : const Text(
                      "Inactive",
                      style: TextStyle(
                        color: Colors.orange,
                      ),
                    ),
              tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
              hoverColor: Colors.grey[100],
              onTap: () => onTapBorrower(b),
            );
          },
        );
      },
    );
  }
}
