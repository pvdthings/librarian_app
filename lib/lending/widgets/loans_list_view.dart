import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/user_model.dart';
import 'package:librarian_app/lending/pages/loan_details_page.dart';
import 'package:provider/provider.dart';

class LoansListView extends StatefulWidget {
  const LoansListView({super.key});

  @override
  State<LoansListView> createState() => _LoansListViewState();
}

class _LoansListViewState extends State<LoansListView> {
  bool _isLoading = false;
  List<Loan> _loans = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  Color? _dueDateColor(Loan loan) {
    if (loan.isOverdue) return Colors.red[100];
    if (loan.isDueToday) return Colors.green[100];
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

    return ListView.builder(
      itemCount: _loans.length,
      itemBuilder: (context, index) {
        final loan = _loans[index];

        return ListTile(
          title: Text(loan.thing.name ?? 'Unknown Thing'),
          subtitle: Text(loan.borrower.name),
          trailing: Text(
            "${loan.dueDate.month}/${loan.dueDate.day}",
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
    );
  }
}
