import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../constants/constants.dart';
import 'custom_appbar.dart';

class WebViewWidget extends StatefulWidget {
  final String websiteLink;
  const WebViewWidget({
    super.key, required this.websiteLink,
  });

  @override
  State<WebViewWidget> createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();
  double progress = 0.0;
  String url = '';

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      supportZoom: false,
      transparentBackground: false,
      disableContextMenu: true,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
      builtInZoomControls: false,
      mixedContentMode: AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
      
    )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark,
      appBar: CustomAppbar(
        title: Text("Standings",style: titleStyle.copyWith(color: dark, fontWeight: FontWeight.bold),),
        prefixWidget: IconButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          icon: const Icon(Icons.arrow_back_ios_new_rounded)
        ),
      ),
      body: InAppWebView(
        key: webViewKey,
        initialUrlRequest: URLRequest(url: Uri.parse(widget.websiteLink)),
        initialOptions: options,
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onLoadStart: (controller, url) {
          setState(() {
            this.url = url.toString();
          });
        },
        androidOnPermissionRequest: (controller, origin, resources) async {
          return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT
          );
        },
        onLoadStop: (controller, url) async {
          setState(() {
            this.url = url.toString();
          });
        },
        onLoadError: (controller, url, code, message) {
        },
        onProgressChanged: (controller, progress) {
          setState(() {
            this.progress = progress / 100;
          });
        },
        onUpdateVisitedHistory: (controller, url, androidIsReload) {
          setState(() {
            this.url = url.toString();
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint(consoleMessage.toString());
        },
      ),
    );
  }
}