import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:frontend/controllers/category_controller.dart';
import 'package:frontend/controllers/items_controller.dart';
import 'package:frontend/models/items.dart';
import 'package:frontend/screens/items_detail_page.dart';
import 'package:frontend/screens/new_items.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final ItemsController itemsController = Get.put(ItemsController());
  final UserController userController = Get.put(UserController());
  final CategoryController categoryController = Get.put(CategoryController());
  final RxList<Items> filteredItems = <Items>[].obs;

  HomeScreen({super.key}) {
    filteredItems.assignAll(itemsController.items);
    categoryController.fetchAllCategories();
  }

  Color getStatusColor(dynamic status) {
    final statusString = status.toString().split('.').last.toLowerCase();
    switch (statusString) {
      case 'available':
        return Colors.green;
      case 'borrowed':
        return Colors.amber;
      case 'Not available':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF0288D1), Color(0xFF01579B)],
                begin: Alignment.topLeft)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.only(top: 30, left: 20, right: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Selamat Datang ${userController.name.value}",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Perangkat Yang Tersedia",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Obx(() {
                    if (itemsController.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (itemsController.items.isEmpty) {
                      return const Center(
                        child: Text("Data tidak ditemukan"),
                      );
                    }
                    return SizedBox(
                      height: 400,
                      child: ListView.separated(
                        itemCount: itemsController.items.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final items = itemsController.items[index];
                          final category = items.category;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ItemsDetailPage(
                                    item: items,
                                    category: category,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Image.network(
                                        "${items.img_url}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                items.name,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(category?.name ??
                                                  'category tidak ditemukan'),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 5),
                                                child: Text(category?.type ??
                                                    'Type tidak diketahui'),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 10),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: getStatusColor(
                                                          items.status)
                                                      .withOpacity(0.1),
                                                  border: Border.all(
                                                    color: getStatusColor(
                                                        items.status),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(12)),
                                                ),
                                                child: Text(
                                                  items.status
                                                      .toString()
                                                      .split('.')
                                                      .last,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade800,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  ElevatedButton(
                      onPressed: () async {
                        await Get.to(NewItems());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF0288D1),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          Text(
                            "Ajukan pinjaman",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 20),
                          )
                        ],
                      ))
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
