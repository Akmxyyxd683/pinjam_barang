enum ItemStatus {
  available,
  borrowed,
  notAvailable,
}

class Items {
  int? id;
  int categoryId;
  String name;
  DateTime createAt;
  ItemStatus status;

  Items({
    this.id,
    required this.categoryId,
    required this.name,
    required this.createAt,
    required this.status,
  });

  factory Items.fromMap(Map<String, dynamic> json) {
    return Items(
      id: json['id'],
      categoryId: json['category_id'],
      name: json['name'],
      createAt: DateTime.parse(json['create_at']),
      status: ItemStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => ItemStatus.notAvailable,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'name': name,
      'create_at': createAt.toIso8601String(),
      'status': status.toString().split('.').last,
    };
  }
}
