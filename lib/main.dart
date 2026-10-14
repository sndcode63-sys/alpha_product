import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/app_binding.dart';
import 'core/app_routes.dart';
import 'core/app_theme.dart';

void main() => runApp(const AlphaApp());

class AlphaApp extends StatelessWidget {
  const AlphaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Alpha Products',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialBinding: AppBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
    );
  }
}
