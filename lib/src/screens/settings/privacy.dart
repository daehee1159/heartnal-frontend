import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: WebView(
          initialUrl: Glob.privacySiteUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );;
  }
}
