import 'package:flutter/material.dart';

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
    return new Scaffold(
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
                          //todo
                          print(_toAddressController.text),
                          print(_enterAmountController.text),
                          print(gasValue)

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
  //点击空白处，关闭键盘
  void closeKeyboard(BuildContext context) {
    print("进去关闭键盘的方法");
    FocusScope.of(context).requestFocus(blankNode);
  }
}