import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_template/core/utils/toast.dart';
import 'package:flutter_template/utils/sputils.dart';

class BackWalletPage extends StatefulWidget {
  @override
  _BackWalletState createState() => _BackWalletState();
}

class _BackWalletState extends State<BackWalletPage> {
  String mnmonic;

  @override
  void initState() {
    super.initState();
    mnmonic = SPUtils.getMnemonic();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("钱包备份"),
      ),
      body: new Center(
        child: new SizedBox(
          height: 120,
          child: Card(
            color: Colors.white60,
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            elevation: 1,
            child: new GestureDetector(
              onTap: (){
                ClipboardData data = new ClipboardData(text:mnmonic.toString().replaceAll('"', ""));
                Clipboard.setData(data);
                ToastUtils.toast("复制成功");
              },
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(mnmonic != null?mnmonic.toString().replaceAll('"', ""):"",
                    style: TextStyle(fontSize: 24,),
                  ),
                ],
              ),
            ),

          ),
        )
      ),
    );

  }

}