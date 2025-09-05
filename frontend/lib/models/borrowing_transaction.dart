import 'package:frontend/models/items.dart';

enum BorrowStatus { requested, approved, rejected, returned, cancelled }

class BorrowingTransaction {
  int? id;
  int userId;
  int itemId;
  BorrowStatus status;
  DateTime? requestedAt;
  DateTime? approvedAt;
  DateTime? borrowedAt;
  DateTime? dueDate;
  DateTime? returnedAt;
  String? description;
  String? location;
  Items? item;

  BorrowingTransaction(
      {this.id,
      required this.userId,
      required this.itemId,
      required this.status,
      this.requestedAt,
      this.approvedAt,
      this.borrowedAt,
      this.dueDate,
      this.returnedAt,
      required this.description,
      required this.location,
      this.item});

  static DateTime? _d(dynamic v) {
    if (v == null) return null;
    if (v is String && v.isEmpty) return null;
    return DateTime.parse(v as String);
  }

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
      requestedAt: _d(json['requested_at'] ?? json['requestedAt']),
      approvedAt: _d(json['approved_at'] ?? json['approvedAt']),
      borrowedAt: _d(json['borrowed_at'] ?? json['borrowedAt']),
      dueDate: _d(json['due_date'] ?? json['dueDate']),
      returnedAt: _d(json['returned_at'] ?? json['returnedAt']),
      description: json['description'] as String?,
      location: json['location'] as String?,
      item: json['item'] != null ? Items.fromMap(json['item']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    String? iso(DateTime? d) => d?.toIso8601String();
    return {
      'id': id,
      'user_id': userId,
      'item_id': itemId,
      'status': status.toString().split('.').last.toUpperCase(),
      'requested_at': iso(requestedAt),
      'approved_at': iso(approvedAt),
      'borrowed_at': iso(borrowedAt),
      'due_date': iso(dueDate),
      'returned_at': iso(returnedAt),
      'description': description,
      'location': location,
    };
  }
}
