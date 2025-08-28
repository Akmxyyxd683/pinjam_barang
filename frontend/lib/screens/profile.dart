import 'package:flutter/material.dart';
import 'package:frontend/controllers/auth_controller.dart';
import 'package:get/get.dart';

class Profile extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage("${userController.profile_img.value}"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "${userController.name.value}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "${userController.role.value} • ${userController.id.value}")
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.person),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text('Informasi Akun'),
                    )
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.notifications),
                    SizedBox(width: 20),
                    Expanded(child: Text('Notifikasi'))
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 20),
                    Expanded(child: Text('Settings'))
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {},
                child: Row(
                  children: [
                    Icon(Icons.help),
                    SizedBox(width: 20),
                    Expanded(child: Text('Bantuan'))
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFF5F6F9),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  final auth = Get.find<AuthController>();
                  auth.logout();
                },
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 20),
                    Expanded(child: Text('Log Out'))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
