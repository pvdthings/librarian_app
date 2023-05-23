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

  late Future<List<Loan>> _loansFuture;

  @override
  void initState() {
    super.initState();

    final loansModel = Provider.of<LoansModel>(context, listen: false);
    _loansFuture = loansModel.getAll();
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
        return FutureBuilder(
          initialData: const [],
          future: _loansFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error!.toString()));
            }

            var loans = snapshot.data as List<Loan>;

            if (loans.isNotEmpty &&
                widget.filter != null &&
                widget.filter!.isNotEmpty) {
              loans = loans.where((loan) {
                final borrowerName = loan.borrower.name.toLowerCase();
                final filterText = widget.filter!.toLowerCase();
                return borrowerName.contains(filterText);
              }).toList();
            }

            return ListView.builder(
              itemCount: loans.length,
              itemBuilder: (context, index) {
                final loan = loans[index];

                return ListTile(
                  title: Text(
                    loan.thing.name ?? 'Unknown Thing',
                    style: loan.isOverdue ? _overdueTextStyle : null,
                  ),
                  subtitle: Text(loan.borrower.name),
                  trailing: Text(
                    loan.isDueToday
                        ? 'Today'
                        : '${loan.dueDate.month}/${loan.dueDate.day}',
                    style: TextStyle(color: _dueDateColor(loan)),
                  ),
                  selected: loan.id == widget.selectedLoan?.id &&
                      loan.thing.id == widget.selectedLoan?.thing.id,
                  onTap: () => widget.onTap?.call(loan),
                  selectedTileColor: Colors.indigoAccent,
                  selectedColor: Colors.white,
                );
              },
              shrinkWrap: true,
            );
          },
        );
      },
    );
  }
}
