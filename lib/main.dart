import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wereat/core/constants/app_constants.dart';
import 'package:wereat/core/theme/app_theme.dart';
import 'package:wereat/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: WereatApp()));
}

class WereatApp extends StatelessWidget {
  const WereatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const HomePage(),
    );
  }
}
