import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:project_akhir/firebase_options.dart';
import 'app/routes/app_pages.dart';
import 'app/utill/keyboard_container';

void dismissKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ScreenUtilInit(
    designSize: const Size(414, 896),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) => GestureDetector(
      onTap: () {
        dismissKeyboard(_);
      },
      child: GetMaterialApp(
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
        builder: (context, child) {
          return KeyboardContainer(child: child!); // Wrap MaterialApp with KeyboardContainer
        },
      ),
    ),
  ));
}
