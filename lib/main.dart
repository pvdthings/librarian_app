import 'package:flutter/material.dart';
import 'package:librarian_app/lending/lending_page.dart';

void main() {
  runApp(const LibrarianApp());
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
