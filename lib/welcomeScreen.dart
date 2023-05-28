import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosjider_hisab/homePage.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          Image.asset('assets/images/accounting.png'),
          Text(
            'মসজিদের হিসাব',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 28.sp,
            ),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      splashIconSize: 250.w,
      duration: 2000,
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.leftToRight,
    );
  }
}
