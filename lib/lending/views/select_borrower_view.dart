import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:provider/provider.dart';

class SelectBorrowerView extends StatelessWidget {
  const SelectBorrowerView({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Consumer<BorrowersModel>(
      builder: (context, model, child) {
        final borrowers = model.all.toList();

        return ListView.builder(
          itemCount: borrowers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(borrowers[index].name),
              subtitle: const Text(
                "Active",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
              tileColor: (index % 2 == 0) ? null : Colors.blueGrey[50],
              hoverColor: Colors.grey[100],
              onTap: onTap,
            );
          },
        );
      },
    );
  }
}
