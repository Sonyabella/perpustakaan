import 'package:flutter/material.dart';
import 'package:perpustakaan/HomePage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  await Supabase.initialize(
    url: 'https://vvimmssgtizzkobxqins.supabase.co', 
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZ2aW1tc3NndGl6emtvYnhxaW5zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE1NTM3ODQsImV4cCI6MjA0NzEyOTc4NH0.ceTV6ZDJ7MINSuW92_aV1mgUWiA2Yo3firOxY2hVnVY');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'perpustakaan',
      home: BookListPage(),
    );
  }
}

