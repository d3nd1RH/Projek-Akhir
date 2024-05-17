import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_akhir/firebase_options.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ScreenUtilInit(
    designSize: const Size(414, 896),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) => GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.sp),
          bodyMedium: TextStyle(fontSize: 14.sp),
          displayLarge: TextStyle(fontSize: 24.sp),
        ),
      ),
    ),
  ));
}
