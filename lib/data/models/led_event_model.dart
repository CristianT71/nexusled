class LedEventModel {
  const LedEventModel({
    required this.action,
    required this.previousState,
    required this.newState,
    required this.createdAt,
    required this.latencyMs,
    required this.confirmed,
    this.source = 'app',
    this.platform = 'web',
    this.color,
  });

  final String action;
  final String previousState;
  final String newState;
  final DateTime createdAt;
  final int latencyMs;
  final bool confirmed;
  final String source;
  final String platform;
  final String? color;
}
