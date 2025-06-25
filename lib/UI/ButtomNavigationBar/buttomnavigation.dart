import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple/Reusable/color.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/home_screen.dart';
import 'package:simple/UI/Contact/contact_screen.dart';
import 'package:simple/UI/Login/login.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    LoginPage(),
    ContactScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() => _currentIndex = 0);
          return false;
        } else {
          final shouldExit = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title:  Text("Exit App",
                style: MyTextStyle.f14(appPrimaryColor),),
              content: const Text("Are you sure you want to exit?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child:  Text("No",
                  style: MyTextStyle.f12(appPrimaryColor),),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                    SystemNavigator.pop();
                  },
                  child:  Text("Yes",
                    style: MyTextStyle.f12(appPrimaryColor),),
                ),
              ],
            ),
          );
          return shouldExit ?? false;
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      height: 60,
      color: appPrimaryColor,
      buttonBackgroundColor: SecondaryColor,
      backgroundColor: Colors.transparent,
      animationDuration: const Duration(milliseconds: 300),
      animationCurve: Curves.easeInOut,
      onTap: onTap,
      items: const [
        Icon(Icons.home, color: whiteColor, size: 30),
        Icon(Icons.account_circle, color: whiteColor, size: 30),
        Icon(Icons.contact_phone, color: whiteColor, size: 30),
      ],
    );
  }
}
