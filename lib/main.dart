import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/listing_provider.dart';
import 'services/auth_service.dart';
import 'services/listing_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/verify_email_screen.dart';
import 'screens/home_shell.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const KigaliCityApp());
}

class KigaliCityApp extends StatelessWidget {
  const KigaliCityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppAuthProvider(AuthService()),
        ),
        ChangeNotifierProvider(
          create: (_) => ListingProvider(ListingService()),
        ),
      ],
      child: MaterialApp(
        title: 'Kigali City Services',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AuthGate(),
      ),
    );
  }
}

/// Auth gate: routes based on authentication and email verification state
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();

    switch (auth.status) {
      case AuthStatus.initial:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: kGold),
          ),
        );
      case AuthStatus.unauthenticated:
        return const LoginScreen();
      case AuthStatus.emailUnverified:
        return const VerifyEmailScreen();
      case AuthStatus.authenticated:
        return const HomeShell();
    }
  }
}
