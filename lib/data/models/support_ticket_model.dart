class SupportTicketModel {
  const SupportTicketModel({
    required this.subject,
    required this.category,
    required this.priority,
    required this.description,
    required this.createdAt,
  });

  final String subject;
  final String category;
  final String priority;
  final String description;
  final DateTime createdAt;
}
