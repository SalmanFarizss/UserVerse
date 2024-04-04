import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_verse/core/globals.dart';
import 'package:user_verse/features/auth/screens/login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginScreen(),));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height=MediaQuery.of(context).size.height;
    width=MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: Colors.black,
      body:Center(child: Image.asset('assets/images/logo.png')),
    );
  }
}