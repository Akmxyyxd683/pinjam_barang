import 'package:frontend/models/items.dart';
import 'package:frontend/services/api_services.dart';
import 'package:get/get.dart';

class ItemsController extends GetxController {
  var items = <Items>[].obs;
  var isLoading = false.obs;
  final ApiService apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      final itemList = await apiService.fetchItems();
      items.value = itemList;
    } catch (e) {
      print('Error fetching tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
