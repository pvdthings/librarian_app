import 'package:flutter/material.dart';
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers_view_model.dart';
import 'package:librarian_app/src/features/loans/data/loans_view_model.dart';
import 'package:librarian_app/src/features/authentication/data/user_model.dart';
import 'package:librarian_app/src/features/splash/presentation/splash_page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'src/features/loans/data/things_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublicKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserModel>(
        create: (context) => UserModel(),
      ),
      ChangeNotifierProvider<LoansViewModel>(
        create: (context) => LoansViewModel(),
      ),
      ChangeNotifierProvider<BorrowersViewModel>(
        create: (context) => BorrowersViewModel(),
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashPage(),
      },
    );
  }
}
