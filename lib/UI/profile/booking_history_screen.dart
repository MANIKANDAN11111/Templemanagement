import 'package:flutter/material.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/profile/profile_screen.dart';

class BookingHistoryScreen extends StatelessWidget {
  const BookingHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: appPrimaryColor,
        title: Text(
          'Booking History',
          style: MyTextStyle.f18(whiteColor, weight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 18,),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  (route) => false,
            );
          },),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note,
              size: 80,
              color: greyColor,
            ),
            const SizedBox(height: 20),
            Text(
              'No Bookings Yet',
              style: MyTextStyle.f20(greyColor, weight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'It looks like you haven\'t made any bookings.',
              textAlign: TextAlign.center,
              style: MyTextStyle.f16(greyColor),
            ),
          ],
        ),
      ),
    );
  }
}