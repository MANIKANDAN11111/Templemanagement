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
              title: Text(
                'Temple Management System',
                style: MyTextStyle.f20(whiteColor, weight: FontWeight.bold),
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
            style: MyTextStyle.f32(appPrimaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          contactCardsSection(),
          followUsSection(),
        ],
      ),
    );
  }

  Widget contactCardsSection() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: mainCardBackgroundColor,
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 700) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(child: buildContactCard(icon: Icons.location_on, title: 'Address', content: '123 Temple Street, Chennai')),
                const SizedBox(width: 20),
                Expanded(child: buildContactCard(icon: Icons.phone, title: 'Phone', content: '+91 98765 43210')),
                const SizedBox(width: 20),
                Expanded(child: buildContactCard(icon: Icons.mail, title: 'Mail', content: 'info@temple.com')),
              ],
            );
          } else {
            return Column(
              children: [
                buildContactCard(icon: Icons.location_on, title: 'Address', content: '123 Temple Street, Chennai'),
                const SizedBox(height: 20),
                buildContactCard(icon: Icons.phone, title: 'Phone', content: '+91 98765 43210'),
                const SizedBox(height: 20),
                buildContactCard(icon: Icons.mail, title: 'Mail', content: 'info@temple.com'),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildContactCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      height: 250,
      width: 250,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardBackgroundColorcontact,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: greyColor.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 40),
          ),
          const SizedBox(height: 24),
          Text(title, style: MyTextStyle.f20(textColorcontact), textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(content,
              style: MyTextStyle.f16(secondaryTextColorcontact),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
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
        const SizedBox(height: 40),
        Text("Follow us", style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: mainCardBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
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
