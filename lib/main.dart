import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'views/login_view.dart';
import 'services/auth_service.dart';
import 'views/home_view.dart';
import 'views/profil_view.dart';
import 'views/jurnal_view.dart';
import 'views/jurnal_create_view.dart';
import 'helpers/date_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();
  await DateHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Skanida Teacher',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const HomePage(),
        '/login': (_) => const LoginPage(),
        '/profil': (_) => const ProfilView(),
        '/jurnal': (_) => const JurnalView(),
        '/jurnal/create': (_) => const JurnalCreateView(),
      },
    );
  }
}
