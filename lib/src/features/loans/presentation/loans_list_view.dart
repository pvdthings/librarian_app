import 'package:flutter/material.dart';
import 'package:librarian_app/src/features/loans/data/loans_model.dart';
import 'package:provider/provider.dart';

class LoansListView extends StatefulWidget {
  final String? filter;
  final Function(Loan)? onTap;
  final Loan? selectedLoan;

  const LoansListView({
    super.key,
    this.filter,
    this.onTap,
    this.selectedLoan,
  });

  @override
  State<LoansListView> createState() => _LoansListViewState();
}

class _LoansListViewState extends State<LoansListView> {
  final _overdueTextStyle = const TextStyle(color: Colors.orange);

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    // TODO: Move loading bool to model
    // TODO: Load data when app initially loads
    _isLoading = true;
    final loansModel = Provider.of<LoansModel>(context, listen: false);
    loansModel
        .refresh()
        .onError((error, _) => setState(() => _error = error?.toString()))
        .whenComplete(() => setState(() => _isLoading = false));
  }

  Color? _dueDateColor(Loan loan) {
    if (loan.isOverdue) return Colors.orange[200];
    if (loan.isDueToday) return Colors.green[200];
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoansModel>(
      builder: (context, loans, child) {
        if (_error != null) {
          return Center(child: Text(_error!));
        }

        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var localLoans = loans.loans;

        if (localLoans.isNotEmpty &&
            widget.filter != null &&
            widget.filter!.isNotEmpty) {
          localLoans = localLoans.where((loan) {
            final borrowerName = loan.borrower.name.toLowerCase();
            final filterText = widget.filter!.toLowerCase();
            return borrowerName.contains(filterText);
          }).toList();
        }

        return ListView.builder(
          itemCount: localLoans.length,
          itemBuilder: (context, index) {
            final loan = localLoans[index];

            return ListTile(
              title: Text(loan.thing.name ?? 'Unknown Thing'),
              subtitle: Text(loan.borrower.name),
              trailing: loan.isOverdue
                  ? const Tooltip(
                      message: 'Overdue',
                      child: Icon(Icons.warning_rounded),
                    )
                  : Text(
                      loan.isDueToday
                          ? 'Today'
                          : '${loan.dueDate.month}/${loan.dueDate.day}',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium?.fontSize,
                      ),
                    ),
              selected: loan.id == widget.selectedLoan?.id &&
                  loan.thing.id == widget.selectedLoan?.thing.id,
              onTap: () => widget.onTap?.call(loan),
            );
          },
          shrinkWrap: true,
        );
      },
    );
  }
}
