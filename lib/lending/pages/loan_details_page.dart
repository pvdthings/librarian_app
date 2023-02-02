import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:librarian_app/widgets/placeholder_view.dart';
import 'package:provider/provider.dart';

class LoanDetailsPage extends StatefulWidget {
  const LoanDetailsPage(this.loan, {super.key});

  final Loan loan;

  @override
  State<LoanDetailsPage> createState() => _LoanDetailsPageState();
}

class _LoanDetailsPageState extends State<LoanDetailsPage> {
  bool _editMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Loan Details")),
      body: _editMode
          ? Center(
              child: TextButton(
                onPressed: () {
                  final things =
                      Provider.of<ThingsModel>(context, listen: false);
                  things.checkIn(widget.loan.thing.id);

                  final loans = Provider.of<LoansModel>(context, listen: false);
                  loans.close(widget.loan.id);

                  Navigator.pop(context);
                },
                child: const Text("Close Loan"),
              ),
            )
          : const PlaceholderView(title: "Loan Details"),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _editMode = false;
                });
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.save_rounded),
            )
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _editMode = true;
                });
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.edit_rounded),
            ),
    );
  }
}
