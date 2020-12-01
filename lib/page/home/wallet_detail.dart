import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/router/router.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'dart:convert';

class WalletDetail extends StatefulWidget{
  final String tokenName;
  final String address;
  final String imageUrl;
  WalletDetail(this.tokenName,this.address,this.imageUrl);
  @override
  _WalletDetail createState() => _WalletDetail();
}

class _WalletDetail extends State<WalletDetail>{
  String _balance = '';

  @override
  initState() {
    super.initState();
    print(widget.address);
    print(widget.imageUrl);
    XHttp.postJson("/bool-main/wallet/assets",
        {
          "legalCurrency": "USD",
          "queryList": [{
            "address": widget.address,
            "chain": widget.tokenName,
            "extraInfo": ""
          }]
        }
    ).then((response) => {
      if(response['code'] == 200){
       setState((){
         _balance = response['data']['infoList'][0]['balance'];
       }),
        print(response['data']['infoList'][0]['balance']),
      }
    }
    );

  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.tokenName,style: TextStyle(fontSize: 18),),
          leading: IconButton(
            icon: Icon(Icons.arrow_back,size: 24,),
            onPressed: ()=>{
              Navigator.pop(context)
            },
          ),
        ),
        body: new Container(
          child: new Column(
            children: [
              new Expanded(
                flex: 3,
                child: new Column(
                  children: [
                    new Container(
                      margin:EdgeInsets.only(top: 30,bottom: 8),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            "${widget.imageUrl}",
                            width: 80,
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                    new Column(
                      children: [
                        // data.balance != null ? new Text(""):new Text("00.000"),
                        new Container(
                          margin: EdgeInsets.only(top: 5),
                          child: new Text("≈"+_balance),
                        )
                      ],
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 50),
                        child: new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widget.address !=null ?new Text(widget.address.toString().replaceAll('"', ""),):new Text("null")
                          ],
                        )
                    ),
                    new Container(
                      margin: EdgeInsets.only(top: 80),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Container(
                            margin: EdgeInsets.only(right: 70),
                            child:new RaisedButton(
                              child: new Text("接收"),
                              onPressed: ()=>{
                                // var bool = JSON.decode()

                                XRouter.router.navigateTo(context, "/tokenReceive?address=${Uri.encodeComponent(widget.address.toString().replaceAll('"', ""))}",transition: TransitionType.inFromRight)
                              },
                            ),
                          ),
                          new Container(
                            child: new RaisedButton(
                              child: new Text("转账"),
                              onPressed: ()=>{
                                XRouter.router.navigateTo(context, "/tokenSend?address=${Uri.encodeComponent(widget.address.toString().replaceAll('"', ""))}",transition: TransitionType.inFromRight)
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Divider(color: Colors.grey,),
              new Expanded(
                flex: 2,
                child: new Text("下半部分"),
              )
            ],
          ),
        )
    );
  }


}