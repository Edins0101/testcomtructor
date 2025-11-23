import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickquote/env/enviroment.dart';
import 'package:quickquote/env/theme/app_theme.dart';
import 'package:quickquote/shared/providers/functional_provider.dart';
import 'package:quickquote/shared/providers/navegation_verify_provider.dart';
import 'package:quickquote/shared/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  String environment = const String.fromEnvironment('ENVIRONMENT',
      defaultValue: Environment.dev);
  Environment().initConfig(environment);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appName = Environment().config!.appName;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FunctionalProvider()),
        ChangeNotifierProvider(create: (_) => NavegationVerifyProvider())
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().theme(),
        initialRoute: AppRoutes.initialRoute,
        navigatorObservers: [HeroController()],
        routes: AppRoutes.routes,
        // onGenerateRoute: AppRoutes.onGenerateRoute,
      ),
    );
  }
}
