import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/user_model.dart';
import 'package:librarian_app/lending/pages/loan_details_page.dart';
import 'package:provider/provider.dart';

class LoansListView extends StatefulWidget {
  final String? filter;

  const LoansListView({super.key, this.filter});

  @override
  State<LoansListView> createState() => _LoansListViewState();
}

class _LoansListViewState extends State<LoansListView> {
  final _overdueTextStyle = const TextStyle(color: Colors.orange);

  bool _isLoading = false;
  List<Loan> _loans = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  Color? _dueDateColor(Loan loan) {
    if (loan.isOverdue) return Colors.orange[200];
    if (loan.isDueToday) return Colors.green[200];
    return null;
  }

  Future<void> _fetchLoans() async {
    await Future.delayed(Duration.zero);
    setState(() => _isLoading = true);

    // ignore: use_build_context_synchronously
    final loansModel = Provider.of<LoansModel>(context, listen: false);
    try {
      final loans = await loansModel.getAll();
      setState(() {
        _loans = loans;
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

    if (_loans.isEmpty) {
      final user = Provider.of<UserModel>(context, listen: false);

      return Center(
        child: Text("No loans, ${user.name}!"),
      );
    }

    List<Loan> loans = _loans;

    if (loans.isNotEmpty &&
        widget.filter != null &&
        widget.filter!.isNotEmpty) {
      loans = _loans.where((loan) {
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoanDetailsPage(loan),
              ),
            );
          },
        );
      },
      shrinkWrap: true,
    );
  }
}
