import 'package:assignment/providers/time_provider.dart';
import 'package:assignment/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:assignment/pages/main_menu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Database.init(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_KEY']!);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => TimeProvider()),
    ],
    child: const App(),
  ));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sure! OnTime',
      home: const MainMenu(),
    );
  }
}
