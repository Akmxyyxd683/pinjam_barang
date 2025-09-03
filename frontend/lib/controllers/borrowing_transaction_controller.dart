import 'package:get/get.dart';
import '../models/borrowing_transaction.dart';
import '../services/api_services.dart';
import 'auth_controller.dart';

class BorrowingTransactionController extends GetxController {
  final ApiService apiService = ApiService();
  final transactions = <BorrowingTransaction>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final userController = Get.find<UserController>();
      final all = await apiService.getAllBorrowingTransactions();
      final userId = int.tryParse(userController.id.value) ?? 0;
      transactions.value = all.where((tx) => tx.userId == userId).toList();
    } catch (e) {
      // ignore or handle error
    } finally {
      isLoading.value = false;
    }
  }
}
