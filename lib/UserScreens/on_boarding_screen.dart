import 'package:flutter/material.dart';
import 'package:food_app/UserScreens/login.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final List<Introduction> list = [
    Introduction(
      title: 'Discover',
      subTitle: 'Browse the menu and order directly from the application',
      imageUrl: 'images/screen1.png',
    ),
    Introduction(
      title: 'Wallet',
      subTitle: 'Check out easily using ready to use cash',
      imageUrl: 'images/screen2.png',
    ),
    Introduction(
      title: 'Delivery',
      subTitle: 'Deliver food at your door step',
      imageUrl: 'images/screen3.png',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
         backgroundColor: Colors.white,
      foregroundColor: Color(0xffffAA00),
      introductionList: list,
      skipTextStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        fontSize: 18,
      ),
      onTapSkipButton: ()=>Navigator.pushReplacement(
        context,MaterialPageRoute(builder: (context)=>LogIn()),
      ),
    );
  }
}
