import 'package:flutter/material.dart';
import 'package:frontend/screens/notification.dart';
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/profile.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 70,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -1),
                )
              ]),
          child: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.home),
                text: "Home",
              ),
              Tab(
                icon: Icon(Icons.history),
                text: "Riwayat",
              ),
              Tab(
                icon: Icon(Icons.notifications),
                text: "Notifications",
              ),
              Tab(icon: Icon(Icons.person), text: "Profile")
            ],
            indicatorColor: Color(0xFF0077C2),
            labelColor: Color(0xFF0077C2),
            unselectedLabelColor: Colors.grey,
          ),
        ),
        body: TabBarView(
            children: [HomeScreen(), HistoryScreen(), Notif(), Profile()]),
      ),
    );
  }
}
