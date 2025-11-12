class ChatMessage {
  final String id;
  final String? text;
  final String? productId;
  final bool isDeleted;
  final String sentBy;
  final String sentFor;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    this.text,
    this.productId,
    required this.isDeleted,
    required this.sentBy,
    required this.sentFor,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    String _extractIdentifier(dynamic field) {
      if (field == null) return '';
      if (field is String) {
        return field;
      } else if (field is Map<String, dynamic>) {
        return (field['email'] ?? field['_id'] ?? '').toString();
      }
      return field.toString();
    }

    return ChatMessage(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString(),
      productId: json['product']?.toString(),
      isDeleted: json['isDeleted'] == true,
      sentBy: _extractIdentifier(json['sentBy']),
      sentFor: _extractIdentifier(json['sentFor']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}