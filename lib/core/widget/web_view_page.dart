import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  WebViewPage(this.url, this.title);
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toast',
        onMessageReceived: (JavascriptMessage message) {
          Map<String,dynamic> _boolList = jsonDecode(SPUtils.getBool());
          var  keyStore = jsonEncode(_boolList["keystore"]);
          // print(keyStore);
          // print(message.message);
          flutterWebviewPlugin.evalJavascript('native.getKeyStoreCallBack.resolve($keyStore)');
        });
  }
  @override
  initState() {
    super.initState();
    flutterWebviewPlugin.onStateChanged.listen(
            (WebViewStateChanged webViewState) async {
          switch (webViewState.type) {
            case WebViewState.finishLoad:{
              print("finishLoad");
              ///webview页面加载完之后，注入js，!!!js的注入只能在finishLoad之后
              rootBundle.loadString('assets/test.js')
                  .then((value) => flutterWebviewPlugin.evalJavascript('$value'));
            }
            break;
            case WebViewState.shouldStart:
              print("shouldStart");
              break;
            case WebViewState.startLoad:
              print("startLoad");
              break;
            case WebViewState.abortLoad:
              print("abortLoad");
              break;
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadLocalHTML(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WebviewScaffold(
              url:new Uri.dataFromString(snapshot.data, mimeType: 'text/html').toString(),
              withLocalStorage: true,
              withJavascript: true,
              javascriptChannels: <JavascriptChannel>[_alertJavascriptChannel(context),].toSet(),
              hidden: true,
              key: _scaffoldKey,
              appBar: AppBar(
                title: Text(widget.title, style: TextStyle(fontSize: 15)),
                titleSpacing: 0,
               actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.share),
              onPressed: () {Share.share(widget.url);}),
              ],
              ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
    // return WebviewScaffold(
    // // url: widget.url,
    //         url:new Uri.dataFromString(html, mimeType: 'text/html').toString(),
    //         withLocalStorage: true,
    //         withJavascript: true,
    //         javascriptChannels: <JavascriptChannel>[
    //         _alertJavascriptChannel(context),
    //         ].toSet(),
    //         hidden: true,
    //         key: _scaffoldKey,
    //   appBar: AppBar(
    //     title: Text(widget.title, style: TextStyle(fontSize: 15)),
    //         titleSpacing: 0,
    //         actions: <Widget>[
    //           IconButton(
    //               icon: Icon(Icons.share),
    //         onPressed: () {
    //         Share.share(widget.url);
    //         }),
    //         ],
    //         ),
    //         );

  }
  Future<String> _loadLocalHTML() async {
    return await rootBundle.loadString('assets/html_code.html');
  }


}
