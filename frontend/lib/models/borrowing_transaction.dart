class BorrowingTransaction {
  int? id;
  int userId;
  int itemId;
  DateTime borrowedAt;
  DateTime dueDate;
  DateTime returnedAt;
  String? description;
  String? location;

  BorrowingTransaction({
    this.id,
    required this.userId,
    required this.itemId,
    required this.borrowedAt,
    required this.dueDate,
    required this.returnedAt,
    required this.description,
    required this.location,
  });

  factory BorrowingTransaction.fromMap(Map<String, dynamic> json) {
    return BorrowingTransaction(
      id: json['id'],
      userId: json['user_id'],
      itemId: json['item_id'],
      borrowedAt: DateTime.parse(json['borrowed_at']),
      dueDate: DateTime.parse(json['due_date']),
      returnedAt: DateTime.parse(json['returned_at']),
      description: json['description'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'item_id': itemId,
      'borrowed_at': borrowedAt.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'returned_at': returnedAt.toIso8601String(),
      'description': description,
      'location': location,
    };
  }
}
