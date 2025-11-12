class Chat {
  final String id;
  final List<String> participants;
  final List<String> messages;
  final String status;
  final String? blockedBy;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.participants,
    required this.messages,
    required this.status,
    this.blockedBy,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'] ?? '',
      participants: List<String>.from((json['participants'] as List).map((p) {
        if (p == null) return '';
        if (p is String) {
          return p;
        } else if (p is Map<String, dynamic>) {
          // try email first, then _id as fallback
          return (p['email'] ?? p['_id'] ?? '').toString();
        }
        return p.toString();
      })),
      messages: List<String>.from((json['messages'] as List? ?? []).map((m) {
        if (m == null) return '';
        if (m is String) {
          return m;
        } else if (m is Map<String, dynamic>) {
          // extract message id from nested object
          return (m['_id'] ?? '').toString();
        }
        return m.toString();
      })),
      status: json['status']?.toString() ?? 'active',
      blockedBy: json['blockedBy']?.toString(),
      lastMessageAt: DateTime.parse(json['lastMessageAt']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}