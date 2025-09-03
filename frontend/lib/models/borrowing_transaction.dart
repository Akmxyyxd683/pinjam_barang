enum BorrowStatus { requested, approved, rejected, returned, cancelled }

class BorrowingTransaction {
  int? id;
  int userId;
  int itemId;
  BorrowStatus status;
  DateTime requestedAt;
  DateTime approvedAt;
  DateTime borrowedAt;
  DateTime dueDate;
  DateTime returnedAt;
  String? description;
  String? location;

  BorrowingTransaction({
    this.id,
    required this.userId,
    required this.itemId,
    required this.status,
    required this.requestedAt,
    required this.approvedAt,
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
      status: BorrowStatus.values.firstWhere(
        (e) =>
            e.toString().split('.').last.toUpperCase() ==
            (json['status'] ?? 'REQUESTED').toString().toUpperCase(),
        orElse: () => BorrowStatus.requested,
      ),
      requestedAt: DateTime.parse(json['requested_at']),
      approvedAt: DateTime.parse(json['approved_at']),
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
      'status': status.toString().split('.').last,
      'requested_at': requestedAt.toIso8601String(),
      'approved_at': approvedAt.toIso8601String(),
      'borrowed_at': borrowedAt.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'returned_at': returnedAt.toIso8601String(),
      'description': description,
      'location': location,
    };
  }
}
