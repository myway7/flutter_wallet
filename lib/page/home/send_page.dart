import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_page.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SendPage extends StatefulWidget {
  final String address;
  SendPage(this.address);
  @override
  _SendPage createState() {
    return new _SendPage();
  }
}

class _SendPage extends State{
  FocusNode blankNode = FocusNode();
  double gasValue = 0;
  TextEditingController _toAddressController = TextEditingController();
  TextEditingController _enterAmountController = TextEditingController();
  // TextEditingController _gasValueController = TextEditingController();
  @override
  initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlutterEasyLoading(child:new Scaffold(
      appBar: AppBar(
        title: new Text("转账",style: TextStyle(fontSize: 18),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 24,),
          onPressed: ()=>{
            FocusScope.of(context).requestFocus(FocusNode()),
            Duration(seconds: 1),
            Navigator.pop(context)
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          print("--------11-------");
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: buildTextFild(context),
      ),
    ),
    );
  }

  Widget buildTextFild(BuildContext context){
    return new Container(
      child: new Column(
        children: [
          new Expanded(
              flex: 1,
              child: new Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 20,right: 20),
                  child:  new Row(
                    children: [
                      new Expanded(
                        flex:7,
                        child:  TextField(
                          autofocus: false,
                          controller: _toAddressController,
                          decoration: InputDecoration(
                            labelText: "toAddress",
                            hintText: "对方账号地址",
                            prefixIcon: Icon(Icons.person),
                            // border: InputBorder.none //隐藏下划线
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: IconButton(
                          icon: Icon(Icons.photo_camera),
                          onPressed: ()=>{
                            ToastUtils.toast("正在开发中。。。"),
                          },
                        ),
                      )
                    ],
                  )
              )
          ),
          // Divider(color: Colors.grey,),
          new Expanded(
              flex: 1,
              child: new Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20,right: 20),
                child: TextField(
                  autofocus: false,
                  controller: _enterAmountController,
                  decoration: InputDecoration(
                    labelText: "enterAmount",
                    hintText: "转出总数",
                    prefixIcon: Icon(Icons.attach_money),
                    // border: InputBorder.none //隐藏下划线
                  ),
                ),

              )
          ),
          // Divider(color: Colors.grey,),
          new Expanded(
              flex: 4,
              child: new Container(
                margin: EdgeInsets.only(left: 40,right: 20),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    new Row(
                      children: [
                        new Expanded(
                          flex: 2,
                          child: new Text("转账速率："),
                        ),
                        new Expanded(
                          flex: 7,
                          child: Slider(
                              value: this.gasValue,
                              onChanged: (double value) {
                                setState(() {
                                  this.gasValue = value;
                                });
                              },
                              min: 0,
                              max: 10,
                              divisions: 10,
                              label: '速度：×$gasValue',
                              activeColor: Colors.lightBlueAccent,
                              inactiveColor: Colors.grey,
                              semanticFormatterCallback: (double value) {
                                return '速度：$gasValue';
                              }),
                        )
                      ],
                    ),
                    new Container(
                      width: 120,
                      margin: EdgeInsets.only(top:40,right: 20),
                      child: RaisedButton(
                        child: new Text("确认"),
                        onPressed: ()=>{
                        FocusScope.of(context).requestFocus(FocusNode()),
                          //对用户输入的信息进行校验
                          getSign(),
                          //todo

                        },
                      ),
                    )
                  ],
                ),
              )
          ),
        ],
      ),

    );
  }
 //函数定义
   void getSign() async{
    Map<String,dynamic> _boolList = jsonDecode(SPUtils.getBool());
    var  keyStore = jsonEncode(_boolList["keystore"]);
    var paswwd = "123456";
    var type = "BOOL";
    var rpcUrl="wss://rpc-bool.bool.network";
    var amout = _enterAmountController.text.toString();
    var to = _toAddressController.text.toString();
    var data= '{"passwd": "123456","keyStore":$keyStore,"type": "BOOL","rpcUrl":"wss://rpc-bool.bool.network","amout":"$amout","to":"$to"}';

    // startSign(password,keyStore,type,rpcUrl,amount,to)
    // $paswd,$keyStore,$type,$rpcUrl,$amout,$to
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    await flutterWebViewPlugin.evalJavascript("wallet.startSign($data)");
    // var signMessage = await flutterWebViewPlugin.evalJavascript("wallet.getSign()");
    // var sign = jsonDecode(signMessage);
    EasyLoading.show(status: '交易中...');
    // print(keyStore);
    //dart获取js异步函数返回值的方式
    //方式1：通过倒计时的方式
    const timeout = const Duration(seconds: 30);
    print("currentTimer =" + DateTime.now().toString());
    Timer(timeout, () async {
      //倒计时结束
      var signM = await flutterWebViewPlugin.evalJavascript("wallet.getSign()");
      Map<String,dynamic> sign = jsonDecode(signM);
      print("sign--------");
      print(sign);
      if(sign['sign'] != "0"){
        // Dio dio = new Dio();
        XHttp.postJson("/bool-main/wallet/transfer",{
          "chain": "BOOL",
          "singedData":sign['sign'],
        }).then((response) => {
          if(response['code'] == 200){
            ToastUtils.toast("转账成功"),
          }else if(response['code'] == -100){
            ToastUtils.toast("转账费用不够"),
          }else{
            ToastUtils.toast("转账失败"),
          },
          print(response),

        });
      }
      EasyLoading.dismiss();
      print("afterTimer =" + DateTime.now().toString() );
    });
     //方式2：通过轮询的方式
    // while(sign=="0"){
    //   sign = await flutterWebViewPlugin.evalJavascript("wallet.getSign()");
    //   print("sign---"+sign);
    // }


  }
  //点击空白处，关闭键盘
  void closeKeyboard(BuildContext context) {
    print("进去关闭键盘的方法");
    FocusScope.of(context).requestFocus(blankNode);
  }
}