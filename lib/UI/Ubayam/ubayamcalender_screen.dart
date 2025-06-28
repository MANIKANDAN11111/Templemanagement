import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';
import 'package:simple/UI/Ubayam/ubayambooking_screen.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class UbayamCalendarScreen extends StatelessWidget {
  const UbayamCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const UbayamCalendarScreenView(),
    );
  }
}

class UbayamCalendarScreenView extends StatefulWidget {
  const UbayamCalendarScreenView({super.key});

  @override
  State<UbayamCalendarScreenView> createState() => _UbayamCalendarScreenViewState();
}

class _UbayamCalendarScreenViewState extends State<UbayamCalendarScreenView> {
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Ubayam',
              style: MyTextStyle.f18(Colors.white, weight: FontWeight.bold),
            ),
            backgroundColor: appPrimaryColor,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,size: 18,),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                      (route) => false,
                );
              },
            ),
          ),
          body: mainContainer(),
        );
      },
    );
  }

  Widget mainContainer() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.grey[50]!],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Text(
                'Select the date',
                style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold),
              ),
            ),
            _buildMonthHeader(),
            const SizedBox(height: 8),
            _buildWeekdaysHeader(),
            const Divider(height: 20, thickness: 1),
            Expanded(child: _buildCalendarGrid()),
            if (_selectedDate != null) _buildSelectedDateInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: appPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: appPrimaryColor, size: 28),
            onPressed: () {
              setState(() {
                _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
              });
            },
          ),
          Text(
            DateFormat('MMMM yyyy').format(_currentDate),
            style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: appPrimaryColor, size: 28),
            onPressed: () {
              setState(() {
                _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdaysHeader() {
    return Row(
      children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
          .map((day) => Expanded(
        child: Center(
          child: Text(
            day,
            style: MyTextStyle.f14(
              Colors.grey[700]!,
              weight: FontWeight.bold,
            ),
          ),
        ),
      ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final daysInMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0).day;
    final startingWeekday = firstDayOfMonth.weekday;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: daysInMonth + startingWeekday - 1,
      itemBuilder: (context, index) {
        if (index < startingWeekday - 1) {
          return const SizedBox.shrink();
        }

        final day = index - startingWeekday + 2;
        final date = DateTime(_currentDate.year, _currentDate.month, day);
        final isToday = _isSameDay(date, DateTime.now());
        final isPast = date.isBefore(DateTime.now()) && !isToday;
        final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);

        return GestureDetector(
          onTap: isPast ? null : () => setState(() => _selectedDate = date),
          child: Container(
            decoration: isSelected
                ? BoxDecoration(
              color: appPrimaryColor,
              borderRadius: BorderRadius.circular(12),
            )
                : null,
            child: Center(
              child: Text(
                '$day',
                style: MyTextStyle.f18(
                  isSelected
                      ? Colors.white
                      : isPast
                      ? Colors.grey[400]!
                      : isToday
                      ? appPrimaryColor
                      : Colors.grey[800]!,
                  weight: isSelected || isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedDateInfo() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: Column(
        children: [
          Text(
            'Selected Date for Ubayam:',
            style: MyTextStyle.f16(appPrimaryColor, weight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: appPrimaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: appPrimaryColor.withOpacity(0.2)),
            ),
            child: Text(
              DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate!),
              style: MyTextStyle.f16(Colors.grey[800]!, weight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: appPrimaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _showBookingConfirmation,
              child: Text(
                'Confirm Ubayam Booking',
                style: MyTextStyle.f16(Colors.white, weight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.calendar_today, color: appPrimaryColor, size: 48),
              const SizedBox(height: 16),
              Text('Confirm Ubayam Booking', style: MyTextStyle.f18(appPrimaryColor, weight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text('You are booking Ubayam for:', style: MyTextStyle.f14(Colors.grey[700]!)),
              const SizedBox(height: 8),
              Text(DateFormat('MMMM d, yyyy').format(_selectedDate!), style: MyTextStyle.f16(Colors.black, weight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: appPrimaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel', style: MyTextStyle.f14(appPrimaryColor)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: appPrimaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UbayamBookingScreen(selectedDate: _selectedDate!),
                          ),
                        );
                      },
                      child: Text('Confirm', style: MyTextStyle.f14(Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
