import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/material.dart';

import 'pages/log_page.dart';
import 'pages/profile_page.dart';
import 'pages/qr_scan_page.dart';

class StudentHomeScreen extends StatefulWidget {
  static var route = MaterialPageRoute(
    builder: (context) => StudentHomeScreen(),
  );

  @override
  _StudentHomeScreenState createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  int _selectedPosition = 0;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue,
        labelStyle: TextStyle(
          fontWeight: FontWeight.normal,
        )),
    new TabItem(Icons.layers, "Log", Colors.red),
  ]);

  List<Widget> pages = List.of([
    ProfilePage(),
    LogPage(),
  ]);

  CircularBottomNavigationController _navigationController =
      new CircularBottomNavigationController(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedPosition,
        children: List.generate(tabItems.length, (index) {
          return TickerMode(
            enabled: index == _selectedPosition,
            child: Offstage(
              offstage: index != _selectedPosition,
              child: pages[index],
            ),
          );
        }),
      ),
      bottomNavigationBar: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        selectedCallback: (int selectedPos) {
          setState(() {
            _selectedPosition = selectedPos;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.qr_code_scanner),
        onPressed: () {
          Navigator.of(context).push(QRScanPage.route);
        },
      ),
    );
  }
}
