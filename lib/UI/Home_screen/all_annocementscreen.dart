import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class AllAnnouncementsScreen extends StatelessWidget {
  const AllAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const AllAnnouncementsView(),
    );
  }
}

class AllAnnouncementsView extends StatefulWidget {
  const AllAnnouncementsView({super.key});

  @override
  State<AllAnnouncementsView> createState() => _AllAnnouncementsViewState();
}

class _AllAnnouncementsViewState extends State<AllAnnouncementsView> {
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

  Widget mainContainer() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Announcements",
          style: MyTextStyle.f20(
            whiteColor,
            weight: FontWeight.bold,
          ),
        ),
        backgroundColor: appPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_outlined),
          color: whiteColor,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final item = announcements[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.pink[200]!),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    item["image"]!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: MyTextStyle.f16(
                          appPrimaryColor,
                          weight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["date"]!,
                        style: MyTextStyle.f14(
                          Colors.brown,
                          weight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["desc"]!,
                        style: MyTextStyle.f12(
                          Colors.brown,
                          weight: FontWeight.normal,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state) {
        return mainContainer();
      },
    );
  }
}
