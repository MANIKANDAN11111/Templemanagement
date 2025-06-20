import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/text_styles.dart';
import 'package:simple/UI/Home_screen/imagecarousel.dart';
import 'package:simple/UI/Home_screen/annocement.dart';
import 'package:simple/UI/Home_screen/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const HomeScreenView(),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  const HomeScreenView({
    super.key,
  });

  @override
  HomeScreenViewState createState() => HomeScreenViewState();
}

class HomeScreenViewState extends State<HomeScreenView> {
  // PostLoginModel postLoginModel = PostLoginModel();

  String? errorMessage;
  bool loginLoad = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    Widget mainContainer() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: appPrimaryColor,
          title: Text(
                'Temple Management System',
                style:MyTextStyle.f20(
                  whiteColor,
                  weight: FontWeight.bold,
                ),
              ),
          ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: ImageCarousel(),
                ),
                const SizedBox(height: 10),
                AnnouncementScreen(),
                const SizedBox(height:10),
                ServicesSection(),
                const SizedBox(height:30),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: whiteColor,
        body: BlocBuilder<DemoBloc, dynamic>(
          buildWhen: ((previous, current) {
            return false;
          }),
          builder: (context, dynamic) {
            return mainContainer();
          },
        )
    );
  }
}
