import 'package:flutter/material.dart';
import 'package:librarian_app/lending/widgets/things_list_view.dart';
import 'package:librarian_app/lending/widgets/needs_attention_view.dart';
import 'package:librarian_app/lending/widgets/open_loan_view.dart';
import 'package:librarian_app/lending/widgets/borrowers_list_view.dart';

class OpenLoanPage extends StatefulWidget {
  const OpenLoanPage({super.key});

  @override
  State<OpenLoanPage> createState() => _OpenLoanPageState();
}

class _OpenLoanPageState extends State<OpenLoanPage> {
  late final List<ViewModel> _viewModels;
  int _viewIndex = 0;

  void incrementViewIndex() {
    setState(() {
      _viewIndex += 1;
    });
  }

  void skipToLastViewIndex() {
    setState(() {
      _viewIndex = _viewModels.length - 1;
    });
  }

  @override
  void initState() {
    _viewModels = [
      ViewModel(
        title: "Select Borrower",
        body: BorrowersListView(
          onTapActiveBorrower: incrementViewIndex,
          onTapInactiveBorrower: skipToLastViewIndex,
        ),
      ),
      ViewModel(
        title: "Add Things",
        body: const ThingsListView(),
        floatingActionButton: FloatingActionButton(
          onPressed: incrementViewIndex,
          backgroundColor: Colors.orange,
          child: const Icon(
            Icons.navigate_next_rounded,
            size: 30,
          ),
        ),
      ),
      ViewModel(
        title: "Loan Details",
        body: const OpenLoanView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.check_rounded,
            size: 30,
          ),
        ),
      ),
      ViewModel(
        title: "Inactive Borrower",
        body: const NeedsAttentionView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.orange,
          child: const Icon(
            Icons.close_rounded,
            size: 30,
          ),
        ),
      ),
    ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_viewModels[_viewIndex].title)),
      body: _viewModels[_viewIndex].body,
      floatingActionButton: _viewModels[_viewIndex].floatingActionButton,
    );
  }
}

class ViewModel {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;

  const ViewModel({
    required this.title,
    required this.body,
    this.floatingActionButton,
  });
}
