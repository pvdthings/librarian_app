import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/borrowers/data/borrower_model.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_issues.dart';
import 'package:librarian_app/src/features/borrowers/presentation/borrower_search_delegate.dart';
import 'package:librarian_app/src/features/loans/data/thing_model.dart';
import 'package:librarian_app/src/features/loans/presentation/checkout_stepper/connected_thing_search_field.dart';
import 'package:librarian_app/src/features/loans/presentation/loan_details.dart';

class CheckoutStepper extends StatefulWidget {
  const CheckoutStepper({super.key});

  @override
  State<CheckoutStepper> createState() => _CheckoutStepperState();
}

class _CheckoutStepperState extends State<CheckoutStepper> {
  int _index = 0;
  BorrowerModel? _borrower;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 7));

  final List<ThingModel> _things = [];

  bool get _canContinue {
    return _borrower != null && (_borrower?.active ?? false) && _index < 2;
  }

  void _finish() {}

  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepTapped: (value) {
        if (value < _index) {
          setState(() => _index = value);
        }
      },
      onStepContinue: () {
        if (_canContinue) {
          setState(() => _index++);
          return;
        }

        if (_index == 2) {
          _finish();
        }
      },
      onStepCancel: _index > 0
          ? () {
              setState(() => _index--);
            }
          : null,
      steps: [
        Step(
          title: const Text('Select Borrower'),
          subtitle: _borrower != null ? Text(_borrower!.name) : null,
          content: Column(
            children: [
              TextField(
                controller: TextEditingController(text: _borrower?.name),
                decoration: const InputDecoration(
                  labelText: 'Borrower',
                  prefixIcon: Icon(Icons.person_rounded),
                ),
                onTap: () async {
                  final borrower = await showSearch(
                    context: context,
                    delegate: BorrowerSearchDelegate(),
                    useRootNavigator: true,
                  );

                  if (borrower != null) {
                    setState(() => _borrower = borrower);
                  }
                },
              ),
              if (_borrower != null && !_borrower!.active) ...[
                const SizedBox(height: 16),
                BorrowerIssues(
                  borrowerId: _borrower!.id,
                  issues: _borrower!.issues,
                  onRecordCashPayment: (_) {},
                ),
              ],
            ],
          ),
          isActive: _index >= 0,
        ),
        Step(
          title: const Text('Add Things'),
          subtitle: Text(
              '${_things.length} Thing${_things.length == 1 ? '' : 's'} Added'),
          content: Column(
            children: [
              ConnectedThingSearchField(
                controller: ThingSearchController(
                  context: context,
                  onMatchFound: (thing) {
                    setState(() => _things.add(thing));
                  },
                ),
              ),
              const SizedBox(height: 8),
              ListView.builder(
                itemCount: _things.length,
                itemBuilder: (context, index) {
                  final thing = _things[index];
                  return Card(
                    child: ListTile(
                      leading: Text('#${thing.number}'),
                      title: Text(thing.name ?? 'Unknown'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_rounded),
                        onPressed: () {
                          setState(() => _things.remove(thing));
                        },
                        tooltip: 'Remove #${thing.number}',
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
              ),
            ],
          ),
          isActive: _index >= 1,
        ),
        Step(
          title: const Text('Confirm Details'),
          content: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: LoanDetails(
              borrower: _borrower,
              things: _things,
              checkedOutDate: DateTime.now(),
              dueDate: _dueDate,
              onDueDateUpdated: (newDate) {
                setState(() => _dueDate = newDate);
              },
            ),
          ),
          isActive: _index >= 2,
        ),
      ],
    );
  }
}
