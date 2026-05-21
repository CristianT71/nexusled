import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/profile_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onLogout,
  });

  final ProfileModel? profile;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final displayName = profile?.fullName.isNotEmpty == true
        ? profile!.fullName
        : 'Usuario NexusLED';
    final initials = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join()
        .toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: AppColors.purpleAccent,
                      backgroundImage: profile?.avatarUrl.isNotEmpty == true
                          ? NetworkImage(profile!.avatarUrl)
                          : null,
                      child: profile?.avatarUrl.isNotEmpty == true
                          ? null
                          : Text(
                              initials.isEmpty ? 'N' : initials,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.ledOn,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.bgSecondary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        profile?.email ?? '',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ProfileChip(
                            label:
                                profile?.authProvider.toUpperCase() ?? 'EMAIL',
                            icon: Icons.verified_user_rounded,
                          ),
                          _ProfileChip(
                            label: profile?.username.isNotEmpty == true
                                ? '@${profile!.username}'
                                : 'Sin username',
                            icon: Icons.alternate_email_rounded,
                          ),
                          _ProfileChip(
                            label: profile?.phone.isNotEmpty == true
                                ? profile!.phone
                                : 'Sin teléfono',
                            icon: Icons.phone_rounded,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen de la cuenta',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final cardWidth = constraints.maxWidth >= 520
                        ? (constraints.maxWidth - 12) / 2
                        : constraints.maxWidth;
                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Nombre completo',
                            value: displayName,
                            icon: Icons.badge_rounded,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Usuario',
                            value: profile?.username.isNotEmpty == true
                                ? '@${profile!.username}'
                                : 'Sin username',
                            icon: Icons.alternate_email_rounded,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Teléfono',
                            value: profile?.phone.isNotEmpty == true
                                ? profile!.phone
                                : 'Sin número guardado',
                            icon: Icons.phone_rounded,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Método de acceso',
                            value:
                                profile?.authProvider.toUpperCase() ?? 'EMAIL',
                            icon: Icons.lock_rounded,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tu perfil sirve para identificar la cuenta activa y revisar los datos básicos sincronizados con Supabase.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    NexusButton(
                      label: 'CERRAR SESIÓN',
                      onPressed: onLogout,
                      icon: Icons.logout_rounded,
                      colors: const [Color(0xFF991B1B), AppColors.ledOff],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.neonBlue),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  const _ProfileInfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.cyanGlow, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
