import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../widgets/common/animated_background.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onBackToLogin,
    required this.loading,
    required this.error,
  });

  final Future<void> Function({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String phone,
  })
  onRegister;
  final VoidCallback onBackToLogin;
  final bool loading;
  final String? error;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }
    await widget.onRegister(
      email: _email.text,
      password: _password.text,
      fullName: _fullName.text,
      username: _username.text,
      phone: _phone.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: GlassCard(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: AppColors.purpleGlow,
                    size: 54,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Registro NexusLED',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crea tu cuenta para controlar dispositivos, guardar eventos y administrar tu configuración IoT.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 22),
                  TextField(
                    controller: _fullName,
                    decoration: const InputDecoration(
                      labelText: 'Nombre completo',
                      prefixIcon: Icon(Icons.badge_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _username,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de usuario',
                      prefixIcon: Icon(Icons.alternate_email_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      prefixIcon: Icon(Icons.phone_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
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
                  const SizedBox(height: 14),
                  TextField(
                    controller: _confirmPassword,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar contraseña',
                      prefixIcon: Icon(Icons.verified_user_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),
                  NexusButton(
                    label: widget.loading ? 'CREANDO CUENTA...' : 'REGISTRARME',
                    onPressed: widget.loading ? null : _submit,
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.loading ? null : widget.onBackToLogin,
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                  if (widget.error != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      widget.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.ledOff,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
