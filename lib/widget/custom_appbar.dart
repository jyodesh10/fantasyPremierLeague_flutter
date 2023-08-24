import 'package:flutter/material.dart';

import '../constants/constants.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppbar({super.key, this.prefixWidget, this.sufixWidget, required this.title});

  final Widget? prefixWidget;
  final Widget? sufixWidget;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 30,bottom: 10 ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            torquise,
            lightgreen
          ],
          begin: Alignment.centerLeft,
          end:  Alignment.centerRight,
          stops: [0.3, 0.7]
        )
      ),
      child: Row(

        children: [
          prefixWidget ?? const SizedBox(width: 20,),
          title,
          const Spacer(),
          sufixWidget ?? const SizedBox(),
        ],
      ),
    );
  }
  
  @override
  Size get preferredSize => const Size(double.infinity, 56);
}