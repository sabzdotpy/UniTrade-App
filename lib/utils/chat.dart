class Chat {
  final String id;
  final List<String> participants;
  final List<Map<String, String>> participantDetails; // stores name and email
  final List<String> messages;
  final String status;
  final String? blockedBy;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Chat({
    required this.id,
    required this.participants,
    required this.participantDetails,
    required this.messages,
    required this.status,
    this.blockedBy,
    required this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    List<Map<String, String>> details = [];
    
    return Chat(
      id: json['_id'] ?? '',
      participants: List<String>.from((json['participants'] as List).map((p) {
        if (p == null) return '';
        if (p is String) {
          return p;
        } else if (p is Map<String, dynamic>) {
          // store name and email for later use
          final email = (p['email'] ?? p['_id'] ?? '').toString();
          final name = (p['name'] ?? email).toString();
          details.add({'email': email, 'name': name});
          
          // return email for participants list
          return email;
        }
        return p.toString();
      })),
      participantDetails: details,
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