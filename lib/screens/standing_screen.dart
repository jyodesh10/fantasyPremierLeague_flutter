import 'package:fantasypl/widget/webview_widget.dart';
import 'package:flutter/material.dart';

class StandingScreen extends StatelessWidget {
  const StandingScreen({super.key, required this.gw});

  final int gw;

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(websiteLink: "https://fantasy.premierleague.com/entry/1454938/event/$gw/" );
  }
}