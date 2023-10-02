import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:librarian_app/constants.dart';
import 'package:librarian_app/src/features/borrowers/data/borrowers.vm.dart';
import 'package:librarian_app/src/features/loans/data/loans.vm.dart';
import 'package:librarian_app/src/features/authentication/data/user.vm.dart';
import 'package:librarian_app/src/features/splash/pages/splash.page.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await supabase.Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabasePublicKey,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserViewModel>(
        create: (context) => UserViewModel(),
      ),
      ChangeNotifierProvider<LoansViewModel>(
        create: (context) => LoansViewModel(),
      ),
      ChangeNotifierProvider<BorrowersViewModel>(
        create: (context) => BorrowersViewModel(),
      ),
    ],
    child: const riverpod.ProviderScope(child: LibrarianApp()),
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
        primaryColor: Colors.deepPurple,
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
