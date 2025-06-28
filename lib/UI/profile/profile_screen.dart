import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/ButtomNavigationBar/buttomnavigation.dart';
import 'package:simple/UI/profile/edit_profile_screen.dart';
import 'package:simple/UI/profile/booking_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ProfileScreenView(),
    );
  }
}

class ProfileScreenView extends StatefulWidget {
  const ProfileScreenView({super.key});

  @override
  ProfileScreenViewState createState() => ProfileScreenViewState();
}

class ProfileScreenViewState extends State<ProfileScreenView> {
  String fullName = "Manikandan";
  String userEmail = "sankarmanikandan24@gmail.com";
  String userPhone = "6379716353";
  String userUsername = "manikandan_s";
  String userAddress = "123 Temple Street, Chennai, Tamil Nadu, India";

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
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: greyColor.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: appPrimaryColor.withOpacity(0.1),
                      child: Icon(Icons.person, size: 60, color: appPrimaryColor),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      fullName,
                      style: MyTextStyle.f20(blackColor, weight: FontWeight.bold),
                    ),
                    Text(
                      userEmail,
                      style: MyTextStyle.f16(greyColor),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+91 $userPhone',
                      style: MyTextStyle.f16(greyColor),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(
                                initialFullName: fullName,
                                initialUsername: userUsername,
                                initialUserEmail: userEmail,
                                initialUserPhone: '+91 $userPhone',
                                initialAddress: userAddress,
                              ),
                            ),
                          );
                          if (result != null && result is Map<String, String>) {
                            setState(() {
                              fullName = result['fullName']!;
                              userUsername = result['username']!;
                              userEmail = result['email']!;
                              userPhone = result['phone']!.replaceAll('+91 ', '');
                              userAddress = result['address']!;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appPrimaryColor,
                          foregroundColor: whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Text(
                          'Edit Profile',
                          style: MyTextStyle.f14(whiteColor, weight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildMenuItem(Icons.person, 'Profile Info', onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      initialFullName: fullName,
                      initialUsername: userUsername,
                      initialUserEmail: userEmail,
                      initialUserPhone: '+91 $userPhone',
                      initialAddress: userAddress,
                    ),
                  ),
                );
                if (result != null && result is Map<String, String>) {
                  setState(() {
                    fullName = result['fullName']!;
                    userUsername = result['username']!;
                    userEmail = result['email']!;
                    userPhone = result['phone']!.replaceAll('+91 ', '');
                    userAddress = result['address']!;
                  });
                }
              }),
              _buildDivider(),
              _buildMenuItem(
                Icons.history,
                'Booking History',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BookingHistoryScreen()),
                  );
                },
              ),
              _buildDivider(),
              _buildMenuItem(Icons.delete_forever, 'Delete My Account',
                  isDestructive: true,
                  onTap: () => _showDeleteAccountDialog(context)),
              _buildDivider(),
              _buildMenuItem(Icons.logout, 'Log Out',
                  isLogout: true,
                  onTap: () => _showLogoutDialog(context)),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {bool isLogout = false, bool isDestructive = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isLogout || isDestructive ? Colors.red : appPrimaryColor),
      title: Text(
        title,
        style: MyTextStyle.f16(isLogout || isDestructive ? Colors.red : blackColor),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: greyColor),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(height: 1, thickness: 0.5, color: greyColor),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: MyTextStyle.f20(appPrimaryColor, weight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: MyTextStyle.f16(blackColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: MyTextStyle.f16(greyColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logging out...')),
                );
              },
              child: Text(
                'Log Out',
                style: MyTextStyle.f16(Colors.red, weight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Account',
            style: MyTextStyle.f20(Colors.red, weight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to permanently delete your account? This action cannot be undone.',
            style: MyTextStyle.f16(blackColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Cancel',
                style: MyTextStyle.f16(greyColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deleting account permanently...')),
                );
              },
              child: Text(
                'Delete',
                style: MyTextStyle.f16(Colors.red, weight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}