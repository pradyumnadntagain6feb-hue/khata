import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
import 'firebase_options.dart';
import 'presentation/screens/splash_screen.dart'; 
import 'state/register_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }
  runApp(const MusterRegisterApp());
}

class MusterRegisterApp extends StatefulWidget {
  const MusterRegisterApp({super.key});

  @override
  State<MusterRegisterApp> createState() => _MusterRegisterAppState();
}

class _MusterRegisterAppState extends State<MusterRegisterApp> {
  late final RegisterProvider _registerProvider;

  @override
  void initState() {
    super.initState();
    _registerProvider = RegisterProvider();
  }

  @override
  void dispose() {
    _registerProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegisterProviderScope(
      provider: _registerProvider,
      child: AnimatedBuilder(
        animation: _registerProvider,
        builder: (context, child) {
          return MaterialApp(
            title: _registerProvider.strings.appTitle,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.bgParchment,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.navyLedger,
                surface: AppColors.bgParchment,
              ),
              fontFamily: 'sans-serif',
              appBarTheme: const AppBarTheme(
                backgroundColor: AppColors.bgParchment,
                elevation: 0,
              ),
            ),
            home: const KhataSplashScreen(),
          );
        },
      ),
    );
  }
}
