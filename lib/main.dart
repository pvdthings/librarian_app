import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => LoansModel(),
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
        primarySwatch: Colors.blue,
      ),
      home: const LendingPage(),
    );
  }
}
