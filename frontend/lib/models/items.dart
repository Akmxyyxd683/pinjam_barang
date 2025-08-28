import 'package:frontend/models/categories.dart';

enum ItemStatus {
  available,
  borrowed,
  notAvailable,
}

class Items {
  int? id;
  int categoryId;
  String name;
  String? img_url;
  DateTime createAt;
  ItemStatus status;
  Categories? category;

  Items(
      {this.id,
      required this.categoryId,
      required this.name,
      required this.img_url,
      required this.createAt,
      required this.status,
      required this.category});

  factory Items.fromMap(Map<String, dynamic> json) {
    return Items(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      img_url: json['img_url'],
      createAt: DateTime.parse(json['create_at']),
      status: ItemStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ItemStatus.notAvailable,
      ),
      category: json['category'] != null
          ? Categories.fromMap(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'img_url': img_url,
      'create_at': createAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}
