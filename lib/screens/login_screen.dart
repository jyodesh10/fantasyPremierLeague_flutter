import 'package:fantasypl/repo/fpl_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: MaterialButton(
            color: Colors.black,
            child: const Text("login"),
            onPressed: (){
              FplApi().login();
            }),
        ) 
      ),
    );
  }
}





