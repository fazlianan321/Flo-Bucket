import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation.dart';

class FloBucketApp extends StatelessWidget {
  const FloBucketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flo Bucket',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const MainNavigation(),
    );
  }
}