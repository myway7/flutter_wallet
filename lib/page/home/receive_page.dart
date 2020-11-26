import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class ReceivePage extends StatelessWidget {
  final String address;
  ReceivePage(this.address);
  @override
  Widget build(BuildContext context) {
    print(this.address);
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        title: new Text("接收",style: TextStyle(fontSize: 18),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,size: 24,),
          onPressed: ()=>{
            Navigator.pop(context)
          },
        ),
      ),
      body: new Center(
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            this.address !="" ? QrImage(
              data: this.address,
              version: QrVersions.auto,
              size: 200.0,
            ):Text("null"),
          ],
        ),
      ),

    );

  }

}