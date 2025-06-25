import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/all_annocementscreen.dart';

class AnnouncementContainer extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final Function(int) onPageChanged;
  final List<Map<String, String>> announcements;

  const AnnouncementContainer({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.onPageChanged,
    required this.announcements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.pink[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Announcements",
                style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllAnnouncementsScreen(),
                    ),
                  );
                },
                child: Text(
                  "View All",
                  style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Carousel
          SizedBox(
            height: 280,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: announcements.length,
              itemBuilder: (context, index) {
                final item = announcements[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink[100]!,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          item["image"]!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        item["title"]!,
                        style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["date"]!,
                        style: MyTextStyle.f14(Colors.brown),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item["desc"]!,
                        textAlign: TextAlign.center,
                        style: MyTextStyle.f14(Colors.brown),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(announcements.length, (int index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: currentPage == index ? 12.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPage == index
                      ? appPrimaryColor
                      : greyColor,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
