import 'package:auto_route/auto_route.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/widget/web_view_page.dart';
import 'package:flutter_template/page/home/send_page.dart';
import 'package:flutter_template/page/home/wallet_detail.dart';
import 'package:flutter_template/page/home/receive_page.dart';
import 'package:flutter_template/router/route_map.gr.dart';

///使用fluro进行路由管理
class XRouter {
  static FluroRouter router;

  static void init() {
    router = FluroRouter();
    configureRoutes(router);
  }

  ///路由配置
  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("route is not find !");
      return null;
    });

    //网页加载
    router.define('/web', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      String title = params['title']?.first;
      String url = params['url']?.first;
      return WebViewPage(url, title);
    }));

    //钱包详情
    router.define('/tokenDetail', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String tokenName = params['tokenName']?.first;
          String address = params['address']?.first;
          String url = params['imageUrl']?.first;
          return WalletDetail(tokenName,address, url);
        }));
    //接收token
    router.define('/tokenReceive', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String address = params['address']?.first;
          return ReceivePage(address);
        }));
    //token交易
    router.define('/tokenSend', handler: Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
          String address = params['address']?.first;
          return SendPage(address);
        }));
  }

  static ExtendedNavigatorState get navigator =>
      ExtendedNavigator.ofRouter<RouterMap>();
}
