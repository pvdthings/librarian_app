import 'package:flutter/material.dart';
import 'package:librarian_app/models/loans_model.dart';
import 'package:librarian_app/widgets/checkin_dialog.dart';
import 'package:librarian_app/widgets/loan_details.dart';
import 'package:librarian_app/widgets/searchable_loans_list.dart';
import 'package:provider/provider.dart';

class LoansDesktopLayout extends StatefulWidget {
  const LoansDesktopLayout({super.key});

  @override
  State<LoansDesktopLayout> createState() => _LoansDesktopLayoutState();
}

class _LoansDesktopLayoutState extends State<LoansDesktopLayout> {
  Loan? _selectedLoan;
  DateTime? _newDueDate;

  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          leading: FloatingActionButton(
            onPressed: () {},
            tooltip: 'New Loan',
            child: const Icon(Icons.add_rounded),
          ),
          labelType: NavigationRailLabelType.selected,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.table_chart_rounded),
              label: Text('Loans'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.people_rounded),
              label: Text('Borrowers'),
            ),
          ],
          selectedIndex: 0,
        ),
        Card(
          margin: const EdgeInsets.all(8),
          child: SizedBox(
            width: 500,
            child: SearchableLoansList(
              onLoanTapped: (loan) {
                setState(() => _selectedLoan = loan);
              },
              selectedLoan: _selectedLoan,
            ),
          ),
        ),
        Expanded(
          child: Consumer<LoansModel>(
            builder: (context, loans, child) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: _selectedLoan == null
                    ? const Center(child: Text('Loan Details'))
                    : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      _selectedLoan!.thing.name!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Chip(
                                        label: Text(
                                            '#${_selectedLoan!.thing.number}'))
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (!_editMode)
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CheckinDialog(
                                                thingNumber:
                                                    _selectedLoan!.thing.number,
                                                onCheckin: () async {
                                                  await loans.closeLoan(
                                                    loanId: _selectedLoan!.id,
                                                    thingId:
                                                        _selectedLoan!.thing.id,
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        tooltip: 'Check in',
                                        icon: const Icon(
                                            Icons.check_circle_rounded),
                                      ),
                                    if (_editMode && _newDueDate != null)
                                      IconButton(
                                        onPressed: () async {
                                          await loans.updateDueDate(
                                            loanId: _selectedLoan!.id,
                                            thingId: _selectedLoan!.thing.id,
                                            dueBackDate: _newDueDate!,
                                          );

                                          setState(() => _editMode = false);
                                        },
                                        icon: const Icon(Icons.save_rounded),
                                        tooltip: 'Save',
                                      ),
                                    const SizedBox(width: 4),
                                    _editMode
                                        ? IconButton(
                                            onPressed: () => setState(
                                                () => _editMode = false),
                                            icon:
                                                const Icon(Icons.close_rounded),
                                            tooltip: 'Cancel',
                                          )
                                        : IconButton(
                                            onPressed: () => setState(
                                                () => _editMode = true),
                                            icon:
                                                const Icon(Icons.edit_rounded),
                                            tooltip: 'Edit',
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          LoanDetails(
                            borrower: _selectedLoan!.borrower,
                            things: [_selectedLoan!.thing],
                            checkedOutDate: _selectedLoan!.checkedOutDate,
                            dueDate: _newDueDate ?? _selectedLoan!.dueDate,
                            onDueDateUpdated: (dueDate) {
                              setState(() => _newDueDate = dueDate);
                            },
                            editable: _editMode,
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
