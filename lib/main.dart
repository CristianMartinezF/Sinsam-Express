import 'package:flutter/material.dart';
import 'config/app_theme.dart';
import 'routes/app_routes.dart';
import 'routes/route_generator.dart';

void main() {
  runApp(const SinSamExpressApp());
}

class SinSamExpressApp extends StatelessWidget {
  const SinSamExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SinSam Express',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generate,
    );
  }
}
