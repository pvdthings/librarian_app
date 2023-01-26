import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:provider/provider.dart';
import 'widgetbook.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LoansModel>(
        create: (context) => LoansModel(),
      ),
      ChangeNotifierProvider<BorrowersModel>(
        create: (context) => BorrowersModel(),
      ),
    ],
    child: const HotReload(),
  ));
}
