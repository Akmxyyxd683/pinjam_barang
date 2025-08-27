import 'dart:convert';
import 'package:frontend/models/borrowing_transaction.dart';
import 'package:frontend/models/categories.dart';
import 'package:frontend/models/items.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000'; // For Android Emulator
  // Use 'http://localhost:3000' for iOS or web testing

  // Authentication
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<List<Items>> fetchItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/items'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((itemsJson) => Items.fromMap(itemsJson))
              .toList();
        }
      }
      return [];
    } catch (e) {
      print('Fetch Items error: $e');
      return [];
    }
  }

  // ==================== BORROWING TRANSACTION CRUD ====================

  // Get all borrowing transactions
  Future<List<BorrowingTransaction>> getAllBorrowingTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/borrowing-transactions'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => BorrowingTransaction.fromMap(json)).toList();
      } else {
        throw Exception(
            'Failed to load borrowing transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching borrowing transactions: $e');
    }
  }

  // Get borrowing transaction by ID
  Future<BorrowingTransaction?> getBorrowingTransactionById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/borrowing-transactions/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return BorrowingTransaction.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception(
            'Failed to load borrowing transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching borrowing transaction: $e');
    }
  }

  // Create new borrowing transaction
  Future<BorrowingTransaction> createBorrowingTransaction(
      BorrowingTransaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/borrowing-transactions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toMap()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body)['data'];
        return BorrowingTransaction.fromMap(data);
      } else {
        throw Exception(
            'Failed to create borrowing transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating borrowing transaction: $e');
    }
  }

  // Update borrowing transaction
  Future<BorrowingTransaction> updateBorrowingTransaction(
      int id, BorrowingTransaction transaction) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/borrowing-transactions/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transaction.toMap()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return BorrowingTransaction.fromMap(data);
      } else {
        throw Exception(
            'Failed to update borrowing transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating borrowing transaction: $e');
    }
  }

  // Delete borrowing transaction
  Future<bool> deleteBorrowingTransaction(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/borrowing-transactions/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting borrowing transaction: $e');
    }
  }

  // ==================== CATEGORIES CRUD ====================

  // Get all categories
  Future<List<Categories>> getAllCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Categories.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  // Get category by ID
  Future<Categories?> getCategoryById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Categories.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category: $e');
    }
  }

  // Create new category
  Future<Categories> createCategory(Categories category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toMap()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body)['data'];
        return Categories.fromMap(data);
      } else {
        throw Exception('Failed to create category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating category: $e');
    }
  }

  // Update category
  Future<Categories> updateCategory(int id, Categories category) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(category.toMap()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Categories.fromMap(data);
      } else {
        throw Exception('Failed to update category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating category: $e');
    }
  }

  // Delete category
  Future<bool> deleteCategory(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/categories/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting category: $e');
    }
  }

  // ==================== ITEMS CRUD ====================

  // Get all items
  Future<List<Items>> getAllItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Items.fromMap(json)).toList();
      } else {
        throw Exception('Failed to load items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  // Get items by category
  Future<List<Items>> getItemsByCategory(int categoryId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items?category_id=$categoryId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Items.fromMap(json)).toList();
      } else {
        throw Exception(
            'Failed to load items by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching items by category: $e');
    }
  }

  // Get items by status
  Future<List<Items>> getItemsByStatus(ItemStatus status) async {
    try {
      final statusString = status.toString().split('.').last;
      final response = await http.get(
        Uri.parse('$baseUrl/items?status=$statusString'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Items.fromMap(json)).toList();
      } else {
        throw Exception(
            'Failed to load items by status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching items by status: $e');
    }
  }

  // Get item by ID
  Future<Items?> getItemById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/items/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Items.fromMap(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to load item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching item: $e');
    }
  }

  // Create new item
  Future<Items> createItem(Items item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/items'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toMap()),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body)['data'];
        return Items.fromMap(data);
      } else {
        throw Exception('Failed to create item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating item: $e');
    }
  }

  // Update item
  Future<Items> updateItem(int id, Items item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/items/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toMap()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Items.fromMap(data);
      } else {
        throw Exception('Failed to update item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating item: $e');
    }
  }

  // Update item status
  Future<Items> updateItemStatus(int id, ItemStatus status) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/items/$id/status'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'status': status.toString().split('.').last}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return Items.fromMap(data);
      } else {
        throw Exception('Failed to update item status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating item status: $e');
    }
  }

  // Delete item
  Future<bool> deleteItem(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/items/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      throw Exception('Error deleting item: $e');
    }
  }

  // ==================== ADDITIONAL METHODS ====================

  // Get available items
  Future<List<Items>> getAvailableItems() async {
    return await getItemsByStatus(ItemStatus.available);
  }

  // Get borrowed items
  Future<List<Items>> getBorrowedItems() async {
    return await getItemsByStatus(ItemStatus.borrowed);
  }

  // Return item (update borrowing transaction)
  Future<BorrowingTransaction> returnItem(int transactionId) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/borrowing-transactions/$transactionId/return'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'returned_at': DateTime.now().toIso8601String()}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        return BorrowingTransaction.fromMap(data);
      } else {
        throw Exception('Failed to return item: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error returning item: $e');
    }
  }
}
