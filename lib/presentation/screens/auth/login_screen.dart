import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onGoToRegister,
    required this.onGoogleLogin,
    required this.onGithubLogin,
    required this.loading,
    required this.error,
  });

  final Future<void> Function(String email, String password) onLogin;
  final VoidCallback onGoToRegister;
  final Future<void> Function() onGoogleLogin;
  final Future<void> Function() onGithubLogin;
  final bool loading;
  final String? error;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 470),
          child: GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.accentGlow,
                  size: 56,
                ),
                const SizedBox(height: 18),
                const Text(
                  'Bienvenido de vuelta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Controla tu hardware desde cualquier lugar con MQTT en tiempo real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Accede con tu cuenta para gestionar tu sistema en tiempo real.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_rounded),
                  ),
                ),
                const SizedBox(height: 20),
                NexusButton(
                  label: widget.loading ? 'CONECTANDO...' : 'INICIAR SESIÓN',
                  onPressed: widget.loading
                      ? null
                      : () => widget.onLogin(_email.text, _password.text),
                  icon: Icons.login_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'O inicia sesión con:',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: widget.loading ? null : widget.onGoogleLogin,
                      icon: const FaIcon(FontAwesomeIcons.google, size: 32),
                      tooltip: 'Google',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.bgSecondary.withValues(alpha: 0.5),
                        foregroundColor: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: widget.loading ? null : widget.onGithubLogin,
                      icon: const FaIcon(FontAwesomeIcons.github, size: 32),
                      tooltip: 'GitHub',
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.bgSecondary.withValues(alpha: 0.5),
                        foregroundColor: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                if (widget.error != null) ...[
                  const SizedBox(height: 14),
                  Text(
                    widget.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.ledOff,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.loading ? null : widget.onGoToRegister,
                  child: const Text('¿No te has registrado? Regístrate'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
