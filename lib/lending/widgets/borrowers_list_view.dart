import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:provider/provider.dart';

class BorrowersListView extends StatefulWidget {
  const BorrowersListView({
    super.key,
    required this.onTapBorrower,
  });

  final void Function(Borrower borrower) onTapBorrower;

  @override
  State<BorrowersListView> createState() => _BorrowersListViewState();
}

class _BorrowersListViewState extends State<BorrowersListView> {
  final _searchController = TextEditingController();
  String? _searchText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (value) {
              setState(() => _searchText = value.toLowerCase());
            },
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Borrower name",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Consumer<BorrowersModel>(
          builder: (context, model, child) {
            var borrowers = model.all.toList();

            if (_searchText != null) {
              borrowers = borrowers
                  .where((b) => b.name.toLowerCase().contains(_searchText!))
                  .toList();
            }

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
                  onTap: () => widget.onTapBorrower(b),
                );
              },
              shrinkWrap: true,
            );
          },
        ),
      ],
    );
  }
}
