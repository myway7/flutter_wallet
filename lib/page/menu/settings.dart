import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_template/generated/i18n.dart';
import 'package:flutter_template/router/route_map.gr.dart';
import 'package:flutter_template/router/router.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text(I18n.of(context).settings)),
        body: SingleChildScrollView(
            child: ListBody(children: <Widget>[
          SizedBox(height: 10),
          ListTile(
              leading: Icon(Icons.color_lens),
              title: Text(I18n.of(context).theme),
              trailing: Icon(Icons.keyboard_arrow_right),
              contentPadding: EdgeInsets.only(left: 20, right: 10),
              onTap: () {
                XRouter.navigator.pushNamed(Routes.themeColorPage);
              }),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(I18n.of(context).language),
            trailing: Icon(Icons.keyboard_arrow_right),
            contentPadding: EdgeInsets.only(left: 20, right: 10),
            onTap: () {
              XRouter.navigator.pushNamed(Routes.languagePage);
            },
          ),
          ListTile(
            leading: Icon(Icons.open_in_browser),
            title: Text("打开H5界面"),
            trailing: Icon(Icons.keyboard_arrow_right),
            contentPadding: EdgeInsets.only(left: 20, right: 10),
            onTap: () {
              ///打开h5页面
              XRouter.router.navigateTo(context,"/web?url=123&title=h5",transition:TransitionType.inFromRight );
            },
          ),
        ])));
  }
}
