import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_template/core/http/http.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/core/widget/loading_dialog.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';
import 'package:flutter_template/utils/sputils.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // 响应空白处的焦点的Node
  bool _isShowPassWord = false;
  bool _isShowPassWordRepeat = false;
  FocusNode blankNode = FocusNode();
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _pwdRepeatController = TextEditingController();
  GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(I18n.of(context).createWallet)),
      appBar:AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(I18n.of(context).createWallet),
      ),
      body: GestureDetector(
        onTap: () {
          // 点击空白页面关闭键盘
          closeKeyboard(context);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: buildForm(context),
        ),
      ),
    );
  }

  //构建表单
  Widget buildForm(BuildContext context) {
    return Form(
      key: _formKey, //设置globalKey，用于后面获取FormState
      autovalidate: false,
      child: Column(
        children: <Widget>[
          TextFormField(
              autofocus: false,
              controller: _unameController,
              decoration: InputDecoration(
                  labelText: I18n.of(context).loginName,
                  hintText: I18n.of(context).loginNameHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.person)),
              //校验用户名
              validator: (v) {
                return v.trim().length > 0
                    ? null
                    : I18n.of(context).loginNameError;
              }),
          TextFormField(
              controller: _pwdController,
              decoration: InputDecoration(
                  labelText: I18n.of(context).password,
                  hintText: I18n.of(context).passwordHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassWord
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: showPassWord)),
              obscureText: !_isShowPassWord,
              //校验密码
              validator: (v) {
                return v.trim().length >= 6
                    ? null
                    : I18n.of(context).passwordError;
              }),

          TextFormField(
              controller: _pwdRepeatController,
              decoration: InputDecoration(
                  labelText: I18n.of(context).repeatPassword,
                  hintText: I18n.of(context).passwordHint,
                  hintStyle: TextStyle(fontSize: 12),
                  icon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                      icon: Icon(
                        _isShowPassWordRepeat
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: showPassWordRepeat)),
              obscureText: !_isShowPassWordRepeat,
              //校验密码
              validator: (v) {
                return v.trim().length >= 6
                    ? null
                    : I18n.of(context).passwordError;
              }),

          // 登录按钮
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Builder(builder: (context) {
                  return RaisedButton(
                    padding: EdgeInsets.all(15.0),
                    child: Text(I18n.of(context).createWallet),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      //由于本widget也是Form的子代widget，所以可以通过下面方式获取FormState
                      // if (Form.of(context).validate()) {
                      //   // onSubmit(context);
                      //   createWallet(context);
                      // }
                      createWallet(context);
                    },
                  );
                })),
              ],
            ),
          )
        ],
      ),
    );
  }

  ///点击控制密码是否显示
  void showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  ///点击控制密码是否显示
  void showPassWordRepeat() {
    setState(() {
      _isShowPassWordRepeat = !_isShowPassWordRepeat;
    });
  }

  void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(blankNode);
  }
  //创建钱包
  void createWallet( BuildContext context){
    closeKeyboard(context);
    print("进入 CallJS");
    print("打印助记词");
    const ETH = "ETH";
    //FlutterWebviewPlugin是一个单例
    final flutterWebViewPlugin = FlutterWebviewPlugin();
    flutterWebViewPlugin.evalJavascript("wallet.getMnemonic()").then((value) =>{
      SPUtils.saveMnemonic(value),
      print(value),
      Duration(seconds: 2),
      flutterWebViewPlugin.evalJavascript('wallet.generateBoolAccount("you","123456",$value)').then((value) =>{
        flutterWebViewPlugin.evalJavascript('wallet.getBoolAccount()').then((value) => {
          SPUtils.saveBool(value),
          XRouter.navigator.pushReplacementNamed(Routes.mainHomePage),
          print("打印bool账户"),
          print(value),
        })
      }),

    });
  }

  //验证通过提交数据
  void onSubmit(BuildContext context) {
    closeKeyboard(context);

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            showContent: false,
            backgroundColor: Colors.black38,
            loadingView: SpinKitCircle(color: Colors.white),
          );
        });

    XHttp.post("/user/register", {
      "username": _unameController.text,
      "password": _pwdController.text,
      "repassword": _pwdRepeatController.text
    }).then((response) {
      Navigator.pop(context);
      if (response['errorCode'] == 0) {
        ToastUtils.toast(I18n.of(context).registerSuccess);
        Navigator.of(context).pop();
      } else {
        ToastUtils.error(response['errorMsg']);
      }
    }).catchError((onError) {
      Navigator.of(context).pop();
      ToastUtils.error(onError);
    });
  }
}
