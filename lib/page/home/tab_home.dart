import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/material_footer.dart';
import 'package:flutter_easyrefresh/material_header.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/grid/grid_item.dart';
import 'package:flutter_template/core/widget/list/article_item.dart';
import 'package:flutter_template/core/widget/list/token_item.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class TabHomePage extends StatefulWidget {
  @override
  _TabHomePageState createState() => _TabHomePageState();
}

class _TabHomePageState extends State<TabHomePage> {
  int _count = 5;
  static Map<String,dynamic> _boolList = jsonDecode(SPUtils.getBool());

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      header: MaterialHeader(),
      footer: MaterialFooter(),
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _count = 5;
          });
        });
      },
      onLoad: () async {
        await Future.delayed(Duration(seconds: 1), () {
          setState(() {
            // _count += 3;
          });
        });
      },
      slivers: <Widget>[
        SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Text(
                  '币种列表',
                  style: TextStyle(fontSize: 18),
                ))),

        //=====列表=====//
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              TokenInfo info = tokens[index];
              return TokenItem(
                  imageUrl: info.imageUrl,
                  tokenName: info.tokenName,
                  address: info.address,
                  balance: info.balance,
                 );
            },
            childCount: _count,
          ),
        ),
      ],
    );
  }

  //这里是演示，所以写死
  // final List<String> urls = [
  //   "http://photocdn.sohu.com/tvmobilemvms/20150907/144160323071011277.jpg", //伪装者:胡歌演绎"痞子特工"
  //   "http://photocdn.sohu.com/tvmobilemvms/20150907/144158380433341332.jpg", //无心法师:生死离别!月牙遭虐杀
  //   "http://photocdn.sohu.com/tvmobilemvms/20150907/144160286644953923.jpg", //花千骨:尊上沦为花千骨
  //   "http://photocdn.sohu.com/tvmobilemvms/20150902/144115156939164801.jpg", //综艺饭:胖轩偷看夏天洗澡掀波澜
  //   "http://photocdn.sohu.com/tvmobilemvms/20150907/144159406950245847.jpg", //碟中谍4:阿汤哥高塔命悬一线,超越不可能
  // ];

  // Widget getBannerWidget() {
  //   return SizedBox(
  //     height: 200,
  //     child: Swiper(
  //       autoplay: true,
  //       duration: 2000,
  //       autoplayDelay: 5000,
  //       itemBuilder: (context, index) {
  //         return Container(
  //           color: Colors.transparent,
  //           child: ClipRRect(
  //               borderRadius: BorderRadius.circular(0),
  //               child: Image(
  //                 fit: BoxFit.fill,
  //                 image: CachedNetworkImageProvider(
  //                   urls[index],
  //                 ),
  //               )),
  //         );
  //       },
  //       onTap: (value) {
  //         ToastUtils.toast("点击--->" + value.toString());
  //       },
  //       itemCount: urls.length,
  //       pagination: SwiperPagination(),
  //     ),
  //   );
  // }


  final List<TokenInfo> tokens = [
    TokenInfo(
      'https://api.bool.network/bool-backstage/pic/token?c=BTC',
      'BTC',
      _boolList["btcAccount"]!= null?_boolList["btcAccount"]:"",
      '0'
      ,),
    TokenInfo(
        'https://api.bool.network/bool-backstage/pic/token?c=ETH',
        'ETH',
      _boolList["ethAccount"]!= null?_boolList["ethAccount"]:"",
        '0'
      ,),
    TokenInfo(
      'https://api.bool.network/bool-backstage/pic/token?c=BOOL',
      'BOOL',
      _boolList["boolAccount"] != null?_boolList["boolAccount"]:"",
      '0'
      ,),
    TokenInfo(
      'https://api.bool.network/bool-backstage/pic/token?c=FIL',
      'FIL',
      _boolList["filAccount"] != null?_boolList["filAccount"]:"",
      '0'
      ,),
    TokenInfo(
      'https://api.bool.network/bool-backstage/pic/token?c=PAD',
      'PAD',
      _boolList["padAccount"] != null?_boolList["padAccount"]:"",
      '0'
      ,),
  ];
}
