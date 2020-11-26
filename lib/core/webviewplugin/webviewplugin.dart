import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
//初始化webview注入js文件
class XWebViewPlugin{
  static XWebViewPlugin xWebView;
   static var webTag = 0;

  static void init(){
    xWebView = new XWebViewPlugin();
      injectJs();
  }

  static void injectJs(){
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.launch(
      'about:blank',
      hidden: true,
      withJavascript: true,
      ignoreSSLErrors: true,
    );
    rootBundle.loadString('assets/js/main.js')
        .then((value) => flutterWebViewPlugin.evalJavascript('$value'));
  }


}