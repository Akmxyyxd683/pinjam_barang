import 'package:frontend/widget/bottom_nav.dart';
import 'package:get/get.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/models/borrowing_transaction.dart';
import 'package:frontend/services/api_services.dart';
import 'package:flutter/material.dart';

class BorrowFormController extends GetxController {
  BorrowFormController({required this.itemId});

  final int itemId;
  final formKey = GlobalKey<FormState>();

  final ApiService apiService = ApiService();
  final UserController userController = Get.find<UserController>();

  // Observable variables
  final startDate = Rxn<DateTime>(DateTime.now().add(const Duration(days: 1)));
  final returnDate = Rxn<DateTime>(DateTime.now().add(const Duration(days: 5)));
  final selectedPurpose = RxnString();
  final isLoading = false.obs;

  // Text controllers
  final descriptionController = TextEditingController(
    text:
        'Diperlukan untuk presentasi project kepada client ABC Company pada tanggal 3 Februari 2025.',
  );
  final locationController = TextEditingController();

  final purposeOptions = [
    'Presentasi Client',
    'Training/Workshop',
    'Project Development',
    'Meeting External',
    'Work From Home',
    'Lainnya',
  ];

  @override
  void onClose() {
    descriptionController.dispose();
    locationController.dispose();
    super.onClose();
  }

  Future<void> selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? startDate.value ?? DateTime.now()
          : returnDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      if (isStartDate) {
        startDate.value = picked;
      } else {
        returnDate.value = picked;
      }
    }
  }

  Future<void> submitForm() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        final userId = int.parse(userController.id.value);
        final transaction = BorrowingTransaction(
          userId: userId,
          itemId: itemId,
          borrowedAt: startDate.value!,
          dueDate: returnDate.value!,
          returnedAt: returnDate.value!,
          description: descriptionController.text,
          location: locationController.text,
        );

        await apiService.createBorrowingTransaction(transaction);
        Get.offAll(() => BottomNav());
        Get.snackbar(
          'Berhasil',
          'Peminjaman berhasil diajukan!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal mengajukan peminjaman',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void saveDraft() {
    isLoading.value = true;

    // Simulate save draft
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.snackbar(
        'Draft Tersimpan',
        'Draft berhasil disimpan!',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Pilih tanggal';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class NewItems extends StatelessWidget {
  final dynamic item;
  final dynamic category;
  const NewItems({super.key, this.item, this.category});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BorrowFormController(itemId: item.id));

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Form Peminjaman',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          "${item.img_url}",
                          fit: BoxFit.cover,
                        )),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? 'Detail item',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '${category.name} • ${category.type}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4EDDA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Tersedia',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF155724),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Start Date
              _buildFormGroup(
                'Tanggal Mulai Peminjaman',
                Obx(() => GestureDetector(
                      onTap: () => controller.selectDate(context, true),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE9ECEF)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formatDate(controller.startDate.value),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    )),
              ),

              const SizedBox(height: 16),

              // Return Date
              _buildFormGroup(
                'Tanggal Pengembalian',
                Obx(() => GestureDetector(
                      onTap: () => controller.selectDate(context, false),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE9ECEF)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller
                                  .formatDate(controller.returnDate.value),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const Icon(Icons.calendar_today,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    )),
              ),

              const SizedBox(height: 16),

              // Purpose Dropdown
              _buildFormGroup(
                'Keperluan Peminjaman',
                Obx(() => DropdownButtonFormField<String>(
                      value: controller.selectedPurpose.value,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE9ECEF)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFFE9ECEF)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Color(0xFF007BFF)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      hint: const Text('Pilih keperluan...'),
                      items: controller.purposeOptions.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        controller.selectedPurpose.value = newValue;
                      },
                    )),
              ),

              const SizedBox(height: 16),

              // Description
              _buildFormGroup(
                'Keterangan Tambahan',
                TextFormField(
                  controller: controller.descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF007BFF)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    hintText: 'Jelaskan detail keperluan peminjaman...',
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Location
              _buildFormGroup(
                'Lokasi Penggunaan',
                TextFormField(
                  controller: controller.locationController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF007BFF)),
                    ),
                    contentPadding: const EdgeInsets.all(16),
                    hintText:
                        'Contoh: Kantor Client, Ruang Meeting B, Work From Home',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Lokasi penggunaan harus diisi';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Warning Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning,
                          color: Color(0xFF856404),
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Perhatian:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF856404),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Peminjaman maksimal 7 hari\n• Harus dikembalikan dalam kondisi baik\n• Denda Rp 50.000/hari untuk keterlambatan\n• Perlu approval untuk peminjaman > 3 hari',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF856404),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Buttons
              Obx(() => Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.submitForm(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF007BFF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Ajukan Peminjaman',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.saveDraft,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6C757D),
                            side: const BorderSide(color: Color(0xFF6C757D)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Simpan sebagai Draft',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormGroup(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
