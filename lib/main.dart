import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LoansModel>(
        create: (context) => LoansModel(),
      ),
      ChangeNotifierProvider<BorrowersModel>(
        create: (context) => BorrowersModel(),
      ),
      ChangeNotifierProvider<ThingsModel>(
        create: (context) => ThingsModel(),
      ),
    ],
    child: const LibrarianApp(),
  ));
}

class LibrarianApp extends StatelessWidget {
  const LibrarianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Librarian',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const LendingPage(),
    );
  }
}
