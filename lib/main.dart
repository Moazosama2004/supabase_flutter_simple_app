import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_flutter_app/views/home_view.dart';
import 'package:supabase_flutter_app/views/login_view.dart';
import 'package:supabase_flutter_app/views/register_view.dart';

import 'views/profile_view.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://utxwprcftgpuskbqsuvb.supabase.co",
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV0eHdwcmNmdGdwdXNrYnFzdXZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMzMzQ3MTUsImV4cCI6MjA1ODkxMDcxNX0.D2nQs-nF22hZBMlVi80GLfF5MCtlG3RZnQoK6W_qJpw',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/register": (context) => RegisterView(),
        "/": (context) => LoginView(),
        "/home": (context) =>HomeView (),
        "/profile": (context) => ProfileView(),
      },
    );
  }
}
