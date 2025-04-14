import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_app/UserScreens/splash_screen.dart';
import 'package:food_app/app_constants.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main()async {
  Stripe.publishableKey=publishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url:"https://zugovfrfadzltqnoezax.supabase.co",
  //   anonKey:"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inp1Z292ZnJmYWR6bHRxbm9lemF4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzU0MDEwNDEsImV4cCI6MjA1MDk3NzA0MX0.bRYB3u9bnbiYxQFxGSTeiCeR5DhK9mnzHhsbliPXlB4",
  // );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
