import 'package:alpha_field_app/imports.dart';
import 'package:alpha_field_app/app/app_pages.dart';
import 'package:alpha_field_app/app/initial_binding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialBinding.initServices();
  runApp(const AlphaApp());
}

class AlphaApp extends StatelessWidget {
  const AlphaApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Alpha Field App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: Routes.splash,
        initialBinding: InitialBinding(),
        getPages: AppPages.pages,
        defaultTransition: Transition.rightToLeft,
      );
}
