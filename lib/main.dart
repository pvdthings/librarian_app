import 'package:flutter/material.dart';
import 'package:librarian_app/lending/models/borrowers_model.dart';
import 'package:librarian_app/lending/models/loans_model.dart';
import 'package:librarian_app/lending/models/things_model.dart';
import 'package:librarian_app/lending/models/user_model.dart';
import 'package:librarian_app/lending/pages/lending_page.dart';
import 'package:librarian_app/lending/pages/signin_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserModel>(
        create: (context) => UserModel(),
      ),
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

class LibrarianApp extends StatefulWidget {
  const LibrarianApp({super.key});

  @override
  State<LibrarianApp> createState() => _LibrarianAppState();
}

class _LibrarianAppState extends State<LibrarianApp> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final home = user.signedIn ? const LendingPage() : const SignInPage();

    return MaterialApp(
      title: 'Librarian',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: home,
    );
  }
}
