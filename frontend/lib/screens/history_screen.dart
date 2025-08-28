import 'package:flutter/material.dart';
import 'package:frontend/controllers/category_controller.dart';
import 'package:frontend/controllers/items_controller.dart';
import 'package:frontend/models/items.dart';
import 'package:get/get.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ItemsController itemsController = Get.put(ItemsController());
  final CategoryController categoryController = Get.put(CategoryController());
  final RxList<Items> filteredItems = <Items>[].obs;

  int selectedIndex = 0;
  final List<String> tabs = ['Semua', 'Aktif', 'Selesai', 'Terlambat', ''];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Peminjaman',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF0288D1), Color(0xFF01579B)])),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8),
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          tabs[index],
                          style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10, left: 20, right: 30),
              child: Obx(() => SizedBox(
                    height: 600,
                    child: ListView.separated(
                      itemCount: itemsController.items.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final items = itemsController.items[index];
                        final category = categoryController.categories[index];

                        // Define colors and text based on status
                        Color getStatusColor() {
                          switch (items.status
                              .toString()
                              .split('.')
                              .last
                              .toLowerCase()) {
                            case 'aktif':
                              return Colors.orange.shade100;
                            case 'terlambat':
                              return Colors.red.shade100;
                            case 'selesai':
                              return Colors.grey.shade200;
                            default:
                              return Colors.blue.shade100;
                          }
                        }

                        Color getStatusTextColor() {
                          switch (items.status
                              .toString()
                              .split('.')
                              .last
                              .toLowerCase()) {
                            case 'aktif':
                              return Colors.orange.shade800;
                            case 'terlambat':
                              return Colors.red.shade800;
                            case 'selesai':
                              return Colors.grey.shade600;
                            default:
                              return Colors.blue.shade800;
                          }
                        }

                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        items.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        items.status.toString().split('.').last,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: getStatusTextColor(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                Text(
                                  '${category?.type} • Dipinjam: 28 Jan 2025', // Replace with actual data
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Due date with color coding
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                    children: [
                                      const TextSpan(text: 'Jatuh tempo: '),
                                      TextSpan(
                                        text:
                                            '2 Feb 2025 (Besok!)', // Replace with actual data
                                        style: TextStyle(
                                          color: items.status
                                                      .toString()
                                                      .split('.')
                                                      .last
                                                      .toLowerCase() ==
                                                  'terdampal'
                                              ? Colors.red
                                              : Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Purpose
                                Text(
                                  'Untuk: Presentasi Client ABC', // Replace with actual data
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Action buttons
                                Row(
                                  children: [
                                    // Different buttons based on status
                                    if (items.status
                                            .toString()
                                            .split('.')
                                            .last
                                            .toLowerCase() ==
                                        'aktif') ...[
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle extend action
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                          ),
                                          child: const Text(
                                            'Perpanjang',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle return action
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                          ),
                                          child: const Text(
                                            'Kembalikan',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ] else if (items.status
                                            .toString()
                                            .split('.')
                                            .last
                                            .toLowerCase() ==
                                        'terdampal') ...[
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle immediate return action
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                          ),
                                          child: const Text(
                                            'Segera Kembalikan - Denda: Rp 350.000',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ] else if (items.status
                                            .toString()
                                            .split('.')
                                            .last
                                            .toLowerCase() ==
                                        'selesai') ...[
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // Handle view details
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Colors.grey.shade400),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8),
                                          ),
                                          child: Text(
                                            'Selesai',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
