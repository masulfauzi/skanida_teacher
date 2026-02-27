import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'views/login_view.dart';
import 'services/auth_service.dart';
import 'views/home_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skanida Teacher',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const HomePage(),
        '/login': (_) => const LoginPage(),
      },
    );
  }
}
