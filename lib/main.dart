import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dashboard/feature/wop/screens/wop_main_layout.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:dashboard/feature/home/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Work Order Planning',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
            useMaterial3: true,
            textTheme: GoogleFonts.dongleTextTheme(),
            fontFamily: GoogleFonts.dongle().fontFamily,
          ),
          home: kIsWeb ? const WOPMainLayout() : const HomeScreen(),
        );
      },
    );
  }
}
