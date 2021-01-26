
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewWidget extends StatefulWidget {
  final String htmlUrl;
  final String pageTitle;

  WebViewWidget({@required this.htmlUrl, this.pageTitle=""});

  @override
  _WebViewWidgetState createState() => _WebViewWidgetState();
}

class _WebViewWidgetState extends State<WebViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.pageTitle}"),
      ),
      backgroundColor: Colors.white,
      body: WebView(initialUrl: widget.htmlUrl,),
    );
  }
}
