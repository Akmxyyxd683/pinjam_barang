import 'package:frontend/models/categories.dart';
import 'package:frontend/services/api_services.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  var isLoading = false.obs;
  var categories = <Categories?>[].obs;
  var selectedCategory = Rxn<Categories?>();
  var errorMessage = ''.obs;

  final ApiService apiService = ApiService();

  Future<void> fetchAllCategories() async {
    try {
      final result = await apiService.getAllCategories();
      categories.assignAll(result);
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
}
