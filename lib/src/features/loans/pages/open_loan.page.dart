import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:librarian_app/src/features/borrowers/data/borrower.model.dart';
import 'package:librarian_app/src/features/loans/data/loans.vm.dart';
import 'package:librarian_app/src/features/loans/widgets/checkout/pick_things.widget.dart';
import 'package:librarian_app/src/features/borrowers/widgets/needs_attention_view.widget.dart';
import 'package:librarian_app/src/features/loans/widgets/loan_details/loan_details.widget.dart';
import 'package:librarian_app/src/features/borrowers/widgets/borrowers_list/searchable_borrowers_list.widget.dart';
import 'package:provider/provider.dart';

import '../data/thing.model.dart';

class OpenLoanPage extends StatefulWidget {
  const OpenLoanPage({super.key});

  @override
  State<OpenLoanPage> createState() => _OpenLoanPageState();
}

class _OpenLoanPageState extends State<OpenLoanPage> {
  OpenLoanView _currentView = OpenLoanView.selectBorrower;

  late String _viewTitle;
  late Widget _body;
  Widget? _floatingActionButton;

  BorrowerModel _borrower = BorrowerModel(id: '', name: "Borrower", issues: []);
  final List<ThingModel> _things = [];
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  void _configureView() {
    switch (_currentView) {
      case OpenLoanView.selectBorrower:
        _viewTitle = "Select Borrower";
        _body = SearchableBorrowersList(onTapBorrower: _onTapBorrower);
        break;
      case OpenLoanView.addThings:
        _viewTitle = "Add Things";
        _body = PickThingsView(
          pickedThings: _things,
          onThingPicked: _onTapThing,
        );
        _floatingActionButton = _things.isNotEmpty
            ? FloatingActionButton.extended(
                onPressed: () =>
                    setState(() => _currentView = OpenLoanView.confirmLoan),
                icon: const Icon(Icons.navigate_next_rounded),
                label: const Text('NEXT'),
              )
            : null;
        break;
      case OpenLoanView.confirmLoan:
        _viewTitle = "Confirm Loan";
        _body = Padding(
          padding: const EdgeInsets.all(16),
          child: LoanDetails(
            borrower: _borrower,
            things: _things,
            checkedOutDate: DateTime.now(),
            dueDate: _dueDate,
            onDueDateUpdated: (newDate) {
              setState(() => _dueDate = newDate);
            },
          ),
        );
        _floatingActionButton = FloatingActionButton.extended(
          onPressed: _onTapCreate,
          icon: const Icon(Icons.check_rounded),
          label: const Text('CONFIRM'),
          backgroundColor: Colors.green,
        );
        break;
      case OpenLoanView.borrowerNeedsAttention:
        _viewTitle = "Ineligible";
        _body = NeedsAttentionView(borrower: _borrower);
        _floatingActionButton = FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.close_rounded),
        );
        break;
    }
  }

  void _onTapBorrower(BorrowerModel borrower) {
    _borrower = borrower;
    if (borrower.active) {
      setState(() => _currentView = OpenLoanView.addThings);
      return;
    }

    setState(() => _currentView = OpenLoanView.borrowerNeedsAttention);
  }

  void _onTapThing(ThingModel thing) {
    setState(() {
      if (_things.contains(thing)) {
        _things.remove(thing);
      } else {
        _things.add(thing);
      }
    });
  }

  Future<void> _onTapCreate() async {
    final loans = Provider.of<LoansViewModel>(context, listen: false);
    final dateFormat = DateFormat('yyyy-MM-dd');

    await loans.openLoan(
      borrowerId: _borrower.id,
      thingIds: _things.map((e) => e.id).toList(),
      checkedOutDate: dateFormat.format(DateTime.now()),
      dueBackDate: dateFormat.format(_dueDate),
    );

    Future.delayed(
      Duration.zero,
      () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _configureView();

    return Scaffold(
      appBar: AppBar(title: Text(_viewTitle)),
      body: _body,
      floatingActionButton: _floatingActionButton,
    );
  }
}

enum OpenLoanView {
  selectBorrower,
  addThings,
  confirmLoan,
  borrowerNeedsAttention
}
