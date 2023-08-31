import 'package:fantasypl/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../constants/constants.dart';
import '../provider/bottom_nav_provider.dart';
import 'fixtures_screen.dart';

class LandingScreen extends ConsumerWidget {
  LandingScreen({super.key});

  final List routes = [
    {
      "name" : "Home",
      "route" : const HomeScreen(),
      "icon" : Icons.home_outlined
    },
    {
      "name" : "Fixture",
      "route" : const FixturesScreen(),
      "icon" : Icons.list_alt
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomNavData = ref.watch(bottomNavProvider);
    return Scaffold(
      backgroundColor: dark,
      body: routes[bottomNavData]["route"],
      bottomNavigationBar: 
      Container(
        height: 60,
        decoration:  BoxDecoration(
          color: torquise.withOpacity(1),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: white.withOpacity(0.5),
              spreadRadius: 1,
              offset: const Offset(0, -4)
            )
          ],
          gradient: LinearGradient(
            colors: [
              dark.withOpacity(1),
              dark.withOpacity(1)
            ],
            begin: Alignment.centerLeft,
            end:  Alignment.centerRight,
            stops: const [0.3, 0.7]
          ),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(routes.length, (index) => buildItem(index,bottomNavData, ref))
        ),
      ),

    );
  }
  
  buildItem(int index, int bottomNavData, WidgetRef ref) {
    return InkWell(
      highlightColor: torquise,
      focusColor: torquise,
      hoverColor: torquise,
      overlayColor: const MaterialStatePropertyAll(torquise),
      splashColor: torquise,
      radius: 20,
      onTap: () {
        ref.read(bottomNavProvider.notifier).changeIndex(index);
      },
      child: 
      index == bottomNavData
        ? Container(
          padding: const EdgeInsets.symmetric(horizontal:12,vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: const GradientBoxBorder(
              gradient: LinearGradient(colors: [torquise, primary]),
              width: 1.6
            ),
          ),
          child: Row(
            children: [
              Icon(routes[index]['icon'], color: torquise, ),
              const SizedBox(
                width: 5,
              ),
              Text(
                routes[index]['name'],
                style: subtitleStyle.copyWith(color: torquise, fontWeight: FontWeight.bold ),
              ),
            ],
          ),
        )
        : TextButton(
          onPressed: (){
            ref.read(bottomNavProvider.notifier).changeIndex(index);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(routes[index]['name'], style: subtitleStyle.copyWith(color: torquise, fontWeight: FontWeight.bold ),),
          ),
        )
    );
  }
}