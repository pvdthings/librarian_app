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
  late List<ViewModel> _viewModels;
  int _viewIndex = 0;

  Borrower _borrower = const Borrower(name: "Borrower");
  final List<Thing> _things = [];
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  void incrementViewIndex() {
    setState(() => _viewIndex += 1);
  }

  void skipToLastViewIndex() {
    setState(() => _viewIndex = _viewModels.length - 1);
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
    setState(() {
      if (_things.contains(thing)) {
        _things.remove(thing);
      } else {
        _things.add(thing);
      }
    });
  }

  void onTapCreate() {
    final things = Provider.of<ThingsModel>(context, listen: false);
    final loans = Provider.of<LoansModel>(context, listen: false);

    for (final thing in _things) {
      things.checkOut(thing.id);
      loans.open(Loan(
        borrower: _borrower,
        thing: Thing(name: thing.name, id: thing.id),
        dueDate: _dueDate,
      ));
    }

    Navigator.pop(context);
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
        body: PickThingsView(
          pickedThings: _things,
          onThingPicked: onTapThing,
        ),
        floatingActionButton: _things.isNotEmpty
            ? FloatingActionButton(
                onPressed: incrementViewIndex,
                child: const Icon(Icons.navigate_next_rounded),
              )
            : null,
      ),
      ViewModel(
        title: "Loan Details",
        body: LoanDetails(
          borrower: _borrower,
          things: _things,
          dueDate: _dueDate,
          onDueDateUpdated: (newDate) {
            setState(() => _dueDate = newDate);
          },
        ),
        floatingActionButton: ConfirmFloatingActionButton(
          onPressed: onTapCreate,
          backgroundColor: Colors.green,
          icon: const Icon(Icons.check_rounded),
          label: "Finish",
        ),
      ),
      ViewModel(
        title: "Ineligible Borrower",
        body: NeedsAttentionView(borrower: _borrower),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pop(context),
          backgroundColor: Colors.green,
          child: const Icon(Icons.close_rounded),
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
