class Categories {
  int? id;
  String name;
  String type;
  String description;
  DateTime createAt;

  Categories(
      {this.id,
      required this.name,
      required this.type,
      required this.description,
      required this.createAt});

  factory Categories.fromMap(Map<String, dynamic> json) {
    return Categories(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        description: json['description'],
        createAt: DateTime.parse(json['create_at']));
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'create_at': createAt.toIso8601String()
    };
  }
}
