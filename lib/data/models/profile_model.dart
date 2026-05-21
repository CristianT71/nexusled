class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.phone,
    required this.avatarUrl,
    required this.authProvider,
    required this.biometricEnabled,
  });

  final String id;
  final String email;
  final String username;
  final String fullName;
  final String phone;
  final String avatarUrl;
  final String authProvider;
  final bool biometricEnabled;

  factory ProfileModel.fromMap(
    Map<String, dynamic> map, {
    required String email,
  }) {
    return ProfileModel(
      id: '${map['id'] ?? ''}',
      email: email,
      username: '${map['username'] ?? ''}',
      fullName: '${map['full_name'] ?? ''}',
      phone: '${map['phone'] ?? ''}',
      avatarUrl: '${map['avatar_url'] ?? ''}',
      authProvider: '${map['auth_provider'] ?? 'email'}',
      biometricEnabled: map['biometric_enabled'] == true,
    );
  }
}
