class SupabaseConfigModel {
  SupabaseConfigModel({
    this.projectUrl = '',
    this.anonKey = '',
    this.enabled = true,
  });

  String projectUrl;
  String anonKey;
  bool enabled;

  bool get isValid => projectUrl.trim().isNotEmpty && anonKey.trim().isNotEmpty;
}
