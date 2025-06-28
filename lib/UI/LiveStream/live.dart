import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/buttomnavigationbar/buttomnavigation.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LiveStreamPage extends StatelessWidget {
  final bool isDarkMode;
  const LiveStreamPage({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: LiveStreamPageView(isDarkMode: isDarkMode),
    );
  }
}

class LiveStreamPageView extends StatefulWidget {
  final bool isDarkMode;
  const LiveStreamPageView({super.key, required this.isDarkMode});

  @override
  State<LiveStreamPageView> createState() => _LiveStreamPageViewState();
}

class _LiveStreamPageViewState extends State<LiveStreamPageView> {
  late bool isDarkMode;
  bool _isLoading = true;
  String? _videoUrl;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
    _fetchLiveStreamStatus();
  }
  void _fetchLiveStreamStatus() async {
    setState(() {
      _isLoading = true;
      _videoUrl = null;
    });

    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _isLoading = false;
      _videoUrl = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      builder: (context, state) {
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
              title: Text(
                'Live Streaming',
                style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
              ),
              backgroundColor: appPrimaryColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 18,),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                        (route) => false,
                  );
                },),
              centerTitle: true,
            ),
            body: mainContainer(),
          ),
        );
      },
    );
  }

  Widget mainContainer() {
    if (_isLoading) {
      return Center(
        child: SpinKitChasingDots(color: appPrimaryColor, size: 40),
      );
    } else if (_videoUrl != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.width * 9 / 16,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text(
                  "Video Player Will Go Here",
                  style: MyTextStyle.f16(whiteColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Live Stream Active!",
              textAlign: TextAlign.center,
              style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.w600),
            ),
            Text(
              "Enjoy the live event.",
              textAlign: TextAlign.center,
              style: MyTextStyle.f16(greyColor),
            ),
          ],
        ),
      );
    } else {
      // No live stream available
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
  }
}