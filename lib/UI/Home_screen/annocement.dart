import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/all_annocementscreen.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/UI/Home_screen/announcement_container.dart';


class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(), // Replace with correct bloc
      child: const AnnouncementView(),
    );
  }
}

class AnnouncementView extends StatefulWidget {
  const AnnouncementView({super.key});

  @override
  State<AnnouncementView> createState() => _AnnouncementViewState();
}

class _AnnouncementViewState extends State<AnnouncementView> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _scrollTimer;
  int _currentPage = 0;

  final List<Map<String, String>> announcements = [
    {
      "title": "CHATURTHI",
      "date": "28-07-2025",
      "desc": "VINAYAGAR MATHA CHATURTHI CELEBRATION",
      "image": Images.vinayagar,
    },
    {
      "title": "POURNAMI",
      "date": "19-08-2025",
      "desc": "FULL MOON POOJA WITH SPECIAL HOMAM",
      "image": Images.pournami,
    },
    {
      "title": "KRISHNA JAYANTHI",
      "date": "25-08-2025",
      "desc": "LORD KRISHNA CELEBRATION WITH DANCE",
      "image": Images.krishna,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _scrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      if (_currentPage < announcements.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget mainContainer()
  {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            AnnouncementContainer(
              pageController: _pageController,
              currentPage: _currentPage,
              onPageChanged: (page) {
                setState(() {
                  _currentPage = page;
                });
              },
              announcements: announcements,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state)  {
        return mainContainer();
      },
    );
  }
}
