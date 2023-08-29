import 'package:fantasypl/constants/constants.dart';
import 'package:flutter/material.dart';

import 'landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double yy = -10;
  double x = 2;
  
  @override
  void initState() {
    super.initState();
    animateZero();
    
  }
  
  animateZero() {
    Future.delayed(const Duration(seconds: 1),
    () =>
      setState(() {
        yy=2.8;
        x=0;
      })
    )
    .then((value) => 
      Future.delayed(const Duration(seconds: 1),
      ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => LandingScreen(),))
      )
    )
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                torquise,
                lightgreen
              ],
              begin: Alignment.centerLeft,
              end:  Alignment.centerRight,
              stops: [0.3, 0.7]
            )
          ),
          child: Center(
            child: Column(
              children: [
                AnimatedSlide(
                  duration: const Duration(milliseconds: 600),
                  offset: Offset(0, yy),
                  curve: Curves.linear,
                  child: Image.asset("assets/pl.png",color: dark,  height: 110,)
                ),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 600),
                  offset: Offset(x, 9),
                  curve: Curves.linear,
                  child: Text("Fantasy PL",style: headingStyle.copyWith(color: dark), ))
              ],
            )
          ),
        )
      )
    );
  }
}