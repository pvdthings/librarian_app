import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:librarian_app/lending/widgets/confirm_floating_action_button.dart';
import 'package:librarian_app/lending/widgets/pick_things_view.dart';
import 'package:librarian_app/lending/widgets/needs_attention_view.dart';
import 'package:librarian_app/lending/widgets/loan_details.dart';
import 'package:librarian_app/lending/widgets/borrowers_list_view.dart';
import 'package:provider/provider.dart';

class OpenLoanPage extends StatefulWidget {
  const OpenLoanPage({super.key});

  @override
  State<OpenLoanPage> createState() => _OpenLoanPageState();
}

class _OpenLoanPageState extends State<OpenLoanPage> {
  late ViewModel _view = selectBorrowerView;

  Borrower _borrower = const Borrower(name: "Borrower");
  final List<Thing> _things = [];
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  void _updateView(ViewModel view) {
    setState(() => _view = view);
  }

  void _onTapBorrower(Borrower borrower) {
    _borrower = borrower;
    if (borrower.active) {
      _updateView(addThingsView);
      return;
    }

    _updateView(needsAttentionView);
  }

  void _onTapThing(Thing thing) {
    setState(() {
      if (_things.contains(thing)) {
        _things.remove(thing);
      } else {
        _things.add(thing);
      }
      _view = addThingsView;
    });
  }

  void _onTapCreate() {
    final things = Provider.of<ThingsModel>(context, listen: false);
    final loans = Provider.of<LoansModel>(context, listen: false);

    for (final thing in _things) {
      things.checkOut(thing.id);
      loans.open(Loan(
        borrower: _borrower,
        thing: Thing(name: thing.name, id: thing.id),
        checkedOutDate: DateTime.now(),
        dueDate: _dueDate,
      ));
    }

    Navigator.pop(context);
  }

  ViewModel get selectBorrowerView => ViewModel(
        title: "Select Borrower",
        body: BorrowersListView(onTapBorrower: _onTapBorrower),
      );

  ViewModel get addThingsView => ViewModel(
        title: "Add Things",
        body: PickThingsView(
          pickedThings: _things,
          onThingPicked: _onTapThing,
        ),
        floatingActionButton: _things.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _updateView(loanDetailsView),
                child: const Icon(Icons.navigate_next_rounded),
              )
            : null,
      );

  ViewModel get loanDetailsView => ViewModel(
        title: "Loan Details",
        body: LoanDetails(
          borrower: _borrower,
          things: _things,
          checkedOutDate: DateTime.now(),
          dueDate: _dueDate,
          onDueDateUpdated: (newDate) {
            setState(() => _dueDate = newDate);
          },
        ),
        floatingActionButton: ConfirmFloatingActionButton(
          onPressed: _onTapCreate,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_rounded),
          label: "Finish",
        ),
      );

  ViewModel get needsAttentionView => ViewModel(
        title: "Ineligible Borrower",
        body: NeedsAttentionView(borrower: _borrower),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.close_rounded),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_view.title)),
      body: _view.body,
      floatingActionButton: _view.floatingActionButton,
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
