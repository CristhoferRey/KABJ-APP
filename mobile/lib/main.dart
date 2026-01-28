import 'package:flutter/material.dart';

import 'core/storage/token_storage.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenStorage.instance.init();
  runApp(const KabjApp());
}

class KabjApp extends StatelessWidget {
  const KabjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KABJ Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ValueListenableBuilder<String?>(
        valueListenable: TokenStorage.instance.tokenNotifier,
        builder: (context, token, _) {
          if (token == null || token.isEmpty) {
            return const LoginScreen();
          }
          return const HomeScreen();
        },
      ),
    );
  }
}
