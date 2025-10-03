class TemplateModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String description;

  TemplateModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.description,
  });

  factory TemplateModel.fromMap(Map<String, dynamic> map) {
    return TemplateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}














