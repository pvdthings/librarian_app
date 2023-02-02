import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
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
  late List<ViewModel> _viewModels;
  int _viewIndex = 0;

  Borrower _borrower = const Borrower(name: "Borrower");
  final List<Thing> _things = [];

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

  void onTapBorrower(Borrower borrower) {
    _borrower = borrower;
    if (borrower.active) {
      incrementViewIndex();
      return;
    }

    skipToLastViewIndex();
  }

  void onTapThing(Thing thing) {
    _things.add(thing);
  }

  @override
  Widget build(BuildContext context) {
    _viewModels = [
      ViewModel(
        title: "Select Borrower",
        body: BorrowersListView(onTapBorrower: onTapBorrower),
      ),
      ViewModel(
        title: "Add Things",
        body: ThingsListView(onTapThing: onTapThing),
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
        body: OpenLoanView(
          borrower: _borrower,
          things: _things,
        ),
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
        title: "Ineligible Borrower",
        body: const NeedsAttentionView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.green,
          child: const Icon(
            Icons.close_rounded,
            size: 30,
          ),
        ),
      ),
    ];

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
