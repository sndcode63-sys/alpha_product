import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'presentation/bindings/app_bindings.dart';
import 'presentation/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialBinding: AppBindings(),
          initialRoute: AppPages.initial,
          getPages: AppPages.pages,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
