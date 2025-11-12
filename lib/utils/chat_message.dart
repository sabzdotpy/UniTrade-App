class ChatMessage {
  final String id;
  final String? text;
  final String? productId;
  final ProductPreview? product;
  final bool isDeleted;
  final String sentBy;
  final String sentFor;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    this.text,
    this.productId,
    this.product,
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

    // handle product field - can be string ID or full object
    String? productIdValue;
    ProductPreview? productPreview;
    
    if (json['product'] != null) {
      if (json['product'] is String) {
        productIdValue = json['product'];
      } else if (json['product'] is Map<String, dynamic>) {
        final productMap = json['product'] as Map<String, dynamic>;
        productIdValue = productMap['_id']?.toString();
        productPreview = ProductPreview.fromJson(productMap);
      }
    }

    return ChatMessage(
      id: json['_id']?.toString() ?? '',
      text: json['text']?.toString(),
      productId: productIdValue,
      product: productPreview,
      isDeleted: json['isDeleted'] == true,
      sentBy: _extractIdentifier(json['sentBy']),
      sentFor: _extractIdentifier(json['sentFor']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ProductPreview {
  final String id;
  final String title;
  final String description;
  final num price;
  final String category;
  final List<String> productImages;

  ProductPreview({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.productImages,
  });

  factory ProductPreview.fromJson(Map<String, dynamic> json) {
    return ProductPreview(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] ?? 0,
      category: json['category']?.toString() ?? '',
      productImages: json['productImages'] != null
          ? List<String>.from(json['productImages'])
          : [],
    );
  }
}