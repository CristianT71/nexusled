import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/profile_model.dart';
import '../../widgets/common/glass_card.dart';
import '../../widgets/common/nexus_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
    required this.profile,
    required this.onLogout,
    required this.onUpdateProfile,
    required this.onUploadAvatar,
  });

  final ProfileModel? profile;
  final VoidCallback onLogout;
  final Future<void> Function(String fullName, String username, String phone) onUpdateProfile;
  final Future<void> Function(String filePath) onUploadAvatar;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  bool _isLoading = false;
  late TextEditingController _fullNameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.profile?.fullName ?? '');
    _usernameController = TextEditingController(text: widget.profile?.username ?? '');
    _phoneController = TextEditingController(text: widget.profile?.phone ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadAvatar() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _isLoading = true);
      try {
        await widget.onUploadAvatar(image.path);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await widget.onUpdateProfile(
        _fullNameController.text,
        _usernameController.text,
        _phoneController.text,
      );
      setState(() => _isEditing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.profile?.fullName.isNotEmpty == true
        ? widget.profile!.fullName
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
                      backgroundImage: widget.profile?.avatarUrl.isNotEmpty == true
                          ? NetworkImage(widget.profile!.avatarUrl)
                          : null,
                      child: widget.profile?.avatarUrl.isNotEmpty == true
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
                      child: GestureDetector(
                        onTap: _pickAndUploadAvatar,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.ledOn,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.bgSecondary,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 16,
                            color: Colors.white,
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
                        widget.profile?.email ?? '',
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _ProfileChip(
                            label:
                                widget.profile?.authProvider.toUpperCase() ?? 'EMAIL',
                            icon: Icons.verified_user_rounded,
                          ),
                          _ProfileChip(
                            label: widget.profile?.username.isNotEmpty == true
                                ? '@${widget.profile!.username}'
                                : 'Sin username',
                            icon: Icons.alternate_email_rounded,
                          ),
                          _ProfileChip(
                            label: widget.profile?.phone.isNotEmpty == true
                                ? widget.profile!.phone
                                : 'Sin teléfono',
                            icon: Icons.phone_rounded,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!_isEditing)
                        NexusButton(
                          label: 'EDITAR PERFIL',
                          onPressed: () => setState(() => _isEditing = true),
                          icon: Icons.edit_rounded,
                        ),
                      if (_isEditing) ...[
                        TextField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: Icon(Icons.badge_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Usuario',
                            prefixIcon: Icon(Icons.alternate_email_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone_rounded),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: NexusButton(
                                label: 'GUARDAR',
                                onPressed: _isLoading ? null : _saveProfile,
                                icon: Icons.save_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: NexusButton(
                                label: 'CANCELAR',
                                onPressed: () {
                                  setState(() {
                                    _isEditing = false;
                                    _fullNameController.text = widget.profile?.fullName ?? '';
                                    _usernameController.text = widget.profile?.username ?? '';
                                    _phoneController.text = widget.profile?.phone ?? '';
                                  });
                                },
                                icon: Icons.cancel_rounded,
                                colors: const [Color(0xFF666666), Color(0xFF444444)],
                              ),
                            ),
                          ],
                        ),
                      ],
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
                            value: widget.profile?.username.isNotEmpty == true
                                ? '@${widget.profile!.username}'
                                : 'Sin username',
                            icon: Icons.alternate_email_rounded,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Teléfono',
                            value: widget.profile?.phone.isNotEmpty == true
                                ? widget.profile!.phone
                                : 'Sin número guardado',
                            icon: Icons.phone_rounded,
                          ),
                        ),
                        SizedBox(
                          width: cardWidth,
                          child: _ProfileInfoCard(
                            title: 'Método de acceso',
                            value:
                                widget.profile?.authProvider.toUpperCase() ?? 'EMAIL',
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
                      onPressed: widget.onLogout,
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
