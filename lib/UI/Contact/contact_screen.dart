import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ContactScreenView(),
    );
  }
}

class ContactScreenView extends StatefulWidget {
  const ContactScreenView({super.key});

  @override
  ContactScreenViewState createState() => ContactScreenViewState();
}

class ContactScreenViewState extends State<ContactScreenView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
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
              backgroundColor: appPrimaryColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      whiteColor,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/image/sentinix_logo1.png',
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Temple Management System',
                    style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
                  ),
                ],
              ),
              centerTitle: true,
            ),
            body: mainContainer(),
          ),
        );
      },
    );
  }

  Widget mainContainer() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Get in Touch',
            style: MyTextStyle.f26(appPrimaryColor, weight: FontWeight.bold),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 40),
          contactCardsSection(),
          const SizedBox(height: 40),
          followUsSection(),
        ],
      ),
    );
  }

  Widget contactCardsSection() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactDetailRow(
            icon: Icons.location_on,
            title: 'Address',
            content: '123 Temple Street\nChennai',
            iconColor: appPrimaryColor,
            contentStyle: MyTextStyle.f16(greyColor800, weight: FontWeight.bold),
          ),
          const Divider(color: greyColor, thickness: 1, height: 30),
          _buildContactDetailRow(
            icon: Icons.phone,
            title: 'Phone',
            content: '+91 9876543210',
            iconColor: appPrimaryColor,
            contentStyle: MyTextStyle.f16(greyColor),
          ),
          const Divider(color: greyColor, thickness: 1, height: 30),
          _buildContactDetailRow(
            icon: Icons.mail,
            title: 'Mail',
            content: 'Info@temple.com',
            iconColor: appPrimaryColor,
            contentStyle: MyTextStyle.f16(greyColor),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailRow({
    required IconData icon,
    required String title,
    required String content,
    required Color iconColor,
    required TextStyle contentStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: MyTextStyle.f20(blackColor, weight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  content,
                  style: MyTextStyle.f16(greyColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget followUsSection() {
    final socialItems = [
      {'icon': 'assets/image/youtube.png', 'label': 'YouTube'},
      {'icon': 'assets/image/facebook.png', 'label': 'Facebook'},
      {'icon': 'assets/image/instagram.png', 'label': 'Instagram'},
      {'icon': 'assets/image/twitter.png', 'label': 'Twitter'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Follow us",
          style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: whiteColor, // White background
            borderRadius: BorderRadius.circular(16), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            physics: const NeverScrollableScrollPhysics(),
            children: socialItems.map((item) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(item['icon']!),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(item['label']!, style: MyTextStyle.f14(blackColor)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
