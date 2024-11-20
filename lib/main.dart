import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_app/Provider/video%20provider.dart';
import 'package:video_player_app/View/Home%20Screen/home.dart';
import 'package:video_player_app/View/Splash%20Screen/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
       routes: {
          '/' : (context)=> SplashScreen(),
          '/home' : (context)=> AhaHomePage(),
       },
      ),
    );
  }
}
