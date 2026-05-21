import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'data/models/register_data_model.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/main_shell.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/state/nexus_led_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env', isOptional: true);
  runApp(const NexusLedApp());
}

class NexusLedApp extends StatefulWidget {
  const NexusLedApp({super.key});

  @override
  State<NexusLedApp> createState() => _NexusLedAppState();
}

class _NexusLedAppState extends State<NexusLedApp> {
  final NexusLedState _state = NexusLedState();
  bool _showSplash = true;
  bool _showRegister = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) setState(() => _showSplash = false);
    });
    _state.addListener(_refresh);
    _state.initialize();
  }

  @override
  void dispose() {
    _state.removeListener(_refresh);
    _state.dispose();
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: _showSplash
          ? const SplashScreen()
          : _state.authenticated
          ? MainShell(state: _state)
          : _showRegister
          ? RegisterScreen(
              onRegister: _register,
              onBackToLogin: () => setState(() => _showRegister = false),
              loading: _state.loading,
              error: _state.lastError,
            )
          : LoginScreen(
              onLogin: _state.login,
              onGoToRegister: () => setState(() => _showRegister = true),
              onGoogleLogin: _state.loginWithGoogle,
              loading: _state.loading,
              error: _state.lastError,
            ),
    );
  }

  Future<void> _register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String phone,
  }) {
    return _state.register(
      RegisterDataModel(
        email: email,
        password: password,
        fullName: fullName,
        username: username,
        phone: phone,
      ),
    );
  }
}
