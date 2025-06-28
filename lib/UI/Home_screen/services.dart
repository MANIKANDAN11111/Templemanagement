import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Archanai_screen/archanai.dart';
import 'package:simple/UI/Donation/donation_page.dart';
import 'package:simple/UI/Hall/hallcalender_screen.dart';
import 'package:simple/UI/LiveStream/live.dart';
import 'package:simple/UI/Prasadam_screen/prasadam.dart';
import 'package:simple/UI/Ubayam/ubayamcalender_screen.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ServicesSectionView(),
    );
  }
}

class ServicesSectionView extends StatefulWidget {
  const ServicesSectionView({super.key});

  @override
  State<ServicesSectionView> createState() => _ServicesSectionViewState();
}

class _ServicesSectionViewState extends State<ServicesSectionView> {
  final List<Map<String, String>> services = [
    {
      'title': 'Donation',
      'subtitle': 'தானம்',
      'icon': 'assets/image/donation.png',
    },
    {
      'title': 'Prasadam Booking',
      'subtitle': 'பிரசாதம் முன்பதிவு',
      'icon': 'assets/image/book.png',
    },
    {
      'title': 'Archanai/Vilaku',
      'subtitle': 'அர்ச்சனை/விளக்கு',
      'icon': 'assets/image/book.png',
    },
    {
      'title': 'Ubayam',
      'subtitle': 'உபயம்',
      'icon': 'assets/image/ubayam.png',
    },
    {
      'title': 'Hall',
      'subtitle': 'மண்டபம்',
      'icon': 'assets/image/book.png',
    },
    // {
    //   'title': 'Virtual Ubayam',
    //   'subtitle': 'மெய்நிகர் உபயம்',
    //   'icon': 'assets/image/ubayam.png',
    // },
    {
      'title': 'Live Streaming',
      'subtitle': '',
      'icon': 'assets/image/live.png',
    },
  ];

  Widget mainContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            'Our Services',
            style: MyTextStyle.f18(
              appPrimaryColor,
              weight: FontWeight.bold,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth < 400 ? 2 : 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                return GestureDetector(
                  onTap: () {
                    if (service['title'] == 'Donation') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (
                            context) => const DonationPage()),
                      );
                    } else if (service['title'] == 'Prasadam Booking') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            PrasadamScreen()),
                      );
                    } else if (service['title'] == 'Archanai/Vilaku') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ArchanaiScreen()),
                      );
                    }
                    else if (service['title'] == 'Live Streaming') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            LiveStreamPage(isDarkMode: false,)),
                      );
                    }
                    else if(service['title']=='Ubayam')
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>UbayamCalendarScreen()));
                    }
                    else if(service['title']=='Hall')
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>HallCalendarScreen()));
                    }
                  },
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            service['icon']!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: Text(
                              service['title']!,
                              textAlign: TextAlign.center,
                              style: MyTextStyle.f16(
                                appPrimaryColor,
                                weight: FontWeight.bold,
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          if (service['subtitle']!.isNotEmpty)
                            Flexible(
                              child: Text(
                                service['subtitle']!,
                                textAlign: TextAlign.center,
                                style: MyTextStyle.f14(
                                  appPrimaryColor,
                                  weight: FontWeight.normal,
                                ),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
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