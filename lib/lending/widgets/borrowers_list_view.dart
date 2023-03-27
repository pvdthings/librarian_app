import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:provider/provider.dart';

import 'submit_text_field.dart';

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
  bool _isLoading = false;
  List<Borrower> _borrowers = [];
  String? _errorMessage;

  final _searchController = TextEditingController();
  String? _searchText;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchBorrowers();
  }

  Future<void> _fetchBorrowers() async {
    await Future.delayed(Duration.zero);
    setState(() => _isLoading = true);

    // ignore: use_build_context_synchronously
    final borrowersModel = Provider.of<BorrowersModel>(context, listen: false);
    try {
      final borrowers = await borrowersModel.getAll();
      setState(() {
        _borrowers = borrowers;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _errorMessage = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    var borrowers = _borrowers;

    if (_searchText != null) {
      borrowers = borrowers
          .where((b) => b.name.toLowerCase().contains(_searchText!))
          .toList();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubmitTextField(
            hintText: "Alice Appleseed",
            labelText: "Borrower",
            prefixIcon: const Icon(Icons.search),
            showSubmitButton: false,
            onChanged: (value) {
              setState(() => _searchText = value.toLowerCase());
            },
            onSubmitted: (_) => {},
            controller: _searchController,
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
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
          ),
        )
      ],
    );
  }
}
