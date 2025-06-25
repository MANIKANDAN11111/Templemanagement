import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple/Reusable/color.dart';
import 'package:simple/Reusable/image.dart';
import 'package:simple/Bloc/demo/demo_bloc.dart';

class ImageCarousel extends StatelessWidget {
  const ImageCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DemoBloc(),
      child: const ImageCarouselView(),
    );
  }
}

class ImageCarouselView extends StatefulWidget {
  const ImageCarouselView({super.key});

  @override
  State<ImageCarouselView> createState() => _ImageCarouselViewState();
}

class _ImageCarouselViewState extends State<ImageCarouselView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _imageUrls = [
    Images.homeimg1,
    Images.homeimg2,
    Images.homeimg3,
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (_currentPage < _imageUrls.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        if (mounted) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeIn,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget mainContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        children: [
          SizedBox(
            height: 220,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imageUrls.length,
              itemBuilder: (context, index) {
                return Image.asset(
                  _imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
              onPageChanged: (index)
              {
                setState(() => _currentPage = index);
              },
            ),
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _imageUrls.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 12 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? appPrimaryColor
                        : whiteColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DemoBloc, dynamic>(
      buildWhen: (previous, current) => false,
      builder: (context, state)
      {
        return mainContainer();
      },
    );
  }
}
