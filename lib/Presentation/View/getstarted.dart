import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPage();
}

class _GetStartedPage extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 1.sw,
        height: 1.sh,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFCF70), // Soft Sunrise Yellow
              Color(0xFFFDB772), // Warm Golden Peach
              Color(0xFFF78A58), // Soft Sunset Orange
              Color(0xFFC96A3A), // Deep Warm Amber
            ],
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.r),
                  child: Image.asset(
                    'assets/images/globe.png',
                    width: 300.w,
                    height: 300.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 200.ms),

            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 25.h),
                child: Text(
                  "Discover your weather with ease stay ",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 500.ms),

            Center(
              child: Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Text(
                  "informed and prepared wherever you go.",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 800.ms),

            const Spacer(),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/weather');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFF4A642),
                    minimumSize: Size(325.w, 65.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Text("Get Started", style: TextStyle(fontSize: 17.sp)),
                ),
              ),
            ).animate().fadeIn(duration: 800.ms, delay: 1100.ms),
          ],
        ),
      ),
    );
  }
}
