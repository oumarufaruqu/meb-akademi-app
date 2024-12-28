import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meb_akademi_app/core/constants/app_constants.dart';
import 'package:meb_akademi_app/core/theme/app_theme.dart';
import 'package:meb_akademi_app/features/courses/presentation/screens/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  await Hive.openBox(AppConstants.userBox);
  await Hive.openBox(AppConstants.coursesBox);
  
  await Supabase.initialize(
    url: 'https://utduzppgtcnsvnpkoedv.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0ZHV6cHBndGNuc3ZucGtvZWR2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNTAxNzcsImV4cCI6MjA1MDkyNjE3N30.Hb8e0OfpkR1D03EUNwBIHMyobSNFe_DWCIKBSWRY668',
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
