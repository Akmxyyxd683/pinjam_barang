import 'package:flutter/material.dart';
import '../controllers/borrowing_transaction_controller.dart';
import '../models/borrowing_transaction.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final BorrowingTransactionController transactionController =
      Get.put(BorrowingTransactionController());

  int selectedIndex = 0;
  final List<String> tabs = [
    'Semua',
    'Requested',
    'Approved',
    'Rejected',
    'Returned',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    transactionController.fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Riwayat Peminjaman',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0288D1), Color(0xFF01579B)])),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(8),
              itemCount: tabs.length,
              itemBuilder: (context, index) {
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => selectedIndex = index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: Obx(() {
              final all = transactionController.transactions;
              final filtered = selectedIndex == 0
                  ? all
                  : all
                      .where((tx) =>
                          tx.status == BorrowStatus.values[selectedIndex - 1])
                      .toList();

              return ListView.separated(
                padding: const EdgeInsets.only(
                    top: 10, left: 20, right: 20, bottom: 10),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final tx = filtered[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text('${tx.item?.name ?? 'Item: ${tx.itemId}'}'),
                      subtitle: Text(
                          'Dipinjam: ${tx.borrowedAt!.toLocal().toString().split(' ').first}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(tx.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          tx.status.toString().split('.').last.toUpperCase(),
                          style: TextStyle(
                            color: _statusTextColor(tx.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _statusColor(BorrowStatus status) {
    switch (status) {
      case BorrowStatus.approved:
        return Colors.green.shade100;
      case BorrowStatus.rejected:
        return Colors.red.shade100;
      case BorrowStatus.returned:
      case BorrowStatus.cancelled:
        return Colors.grey.shade300;
      default:
        return Colors.blue.shade100;
    }
  }

  Color _statusTextColor(BorrowStatus status) {
    switch (status) {
      case BorrowStatus.approved:
        return Colors.green.shade800;
      case BorrowStatus.rejected:
        return Colors.red.shade800;
      case BorrowStatus.returned:
      case BorrowStatus.cancelled:
        return Colors.grey.shade700;
      default:
        return Colors.blue.shade800;
    }
  }
}
