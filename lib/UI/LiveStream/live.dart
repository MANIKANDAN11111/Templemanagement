import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/buttomnavigationbar/buttomnavigation.dart';

class LiveStreamPage extends StatelessWidget {
  final bool isDarkMode;
  const LiveStreamPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return LiveStreamPageView(isDarkMode: isDarkMode);
  }
}

class LiveStreamPageView extends StatefulWidget {
  final bool isDarkMode;
  const LiveStreamPageView({super.key, required this.isDarkMode});

  @override
  LiveStreamPageViewState createState() => LiveStreamPageViewState();
}

class LiveStreamPageViewState extends State<LiveStreamPageView> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContainer() {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.live_tv, size: 80, color: appPrimaryColor),
              const SizedBox(height: 20),
              Text(
                "Live streaming is currently unavailable.",
                textAlign: TextAlign.center,
                style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                "Please check back later for upcoming events.",
                textAlign: TextAlign.center,
                style: MyTextStyle.f16(greyColor),
              ),
            ],
          ),
        ),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()),
                (route) => false,
          );
        }
      },
      child: Scaffold(
          backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text('Live Streaming',
        style: MyTextStyle.f20(whiteColor,weight: FontWeight.bold),),
         backgroundColor: appPrimaryColor,
       iconTheme: const IconThemeData(color: Colors.white),
      ),
        body: mainContainer(),
      ),
    );
  }
}
