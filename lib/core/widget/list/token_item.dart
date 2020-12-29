import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';

/// token详情
class TokenItem extends StatelessWidget {
  final String imageUrl;
  //图片地址
  final String tokenName;
  //token名字
  final String address;
  //token地址
  final String balance;
  //token余额
  final String rpcUrl;

  const TokenItem(
      {Key key,
        this.imageUrl = '',
        this.tokenName = '',
        this.address = '',
        this.balance = '',
        this.rpcUrl = '',
        })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // ToastUtils.toast(address.toString());
          XRouter.router.navigateTo(context,
              "/tokenDetail?tokenName=${Uri.encodeComponent(tokenName)}&address=${Uri.encodeComponent(address)}&imageUrl=${Uri.encodeComponent(imageUrl)}&rpcUrl=${Uri.encodeComponent(rpcUrl)}",
              transition: TransitionType.inFromRight);
          //?url=${Uri.encodeComponent(address)}&title=${Uri.encodeComponent(imageUrl)}
          // XRouter.router.navigateTo(context,
          //     "/web?url=${Uri.encodeComponent(articleUrl)}&title=${Uri.encodeComponent(title)}",
          //     transition: TransitionType.inFromRight);

        },
        child: Card(
            elevation: 2.0,  //设置阴影
            margin: EdgeInsets.fromLTRB(8, 10, 5, 5),
            child:Container(
              child: new Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Expanded(
                      flex: 2,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Container(
                            margin: EdgeInsets.all(10),
                            child: Image.network(
                              "$imageUrl",
                              width: 50,
                              height: 50,
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.all(15),
                            child: Text("$tokenName",style: TextStyle(
                              fontSize: 20,
                            ),),
                          )
                        ],
                      )),
                  new Expanded(
                      flex: 1,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                            child: Text("余额"),
                          ),
                          new Container(
                            child: Text("$balance"),
                          )
                        ],
                      ))

                ],

              ),
            )
        ));
  }
}

class TokenInfo {
  final String imageUrl;
  //图片地址

  final String tokenName;
  //token名字

  final String address;
  //token地址

  final String balance;
  //token余额

  final String rpcUrl;
  //rpc地址
  const TokenInfo(this.imageUrl, this.tokenName, this.address,
      this.balance,this.rpcUrl);
}
