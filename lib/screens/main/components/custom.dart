import 'package:admin/screens/dashbord/dashboard_screen.dart';
import 'package:admin/settingsparent.dart';
import 'package:admin/homeparent.dart';
import 'package:flutter/material.dart';
import 'package:admin/snack.dart';
import 'package:flutter/src/widgets/framework.dart';
class Demo extends MaterialPageRoute<void>{
  Demo({required WidgetBuilder builder}) : super(
      builder: builder);
}

class CustomMenu extends StatefulWidget {

  @override
  State<CustomMenu> createState() => _CustomMenuState();
}

class _CustomMenuState extends State<CustomMenu> {
  bool _active= true;
  bool _active2 = false;
  bool _active3 = false;
  bool _active4 = false;
  bool _active5 = false;
  bool _active6 = false;
  bool _active7 = false;

  TextStyle _activeone(){
    return TextStyle(
        color: Colors.blue,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontSize: 30
    );
  }

  TextStyle _notactive(){
    return TextStyle(
      color: Colors.blue,
    );
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Drawer(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Home",
                style: _active? _activeone(): _notactive(),
              ),
              leading: Icon(
                Icons.home,

              ),
              onTap: () {
                setState(() {
                  _active= true;
                  _active2 = false;
                  _active3 = false;
                  _active4 = false;
                  _active5 = false;
                  _active6 = false;
                  _active7 = false;
                });
                Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => HomeParent()), (route) => false);

              },
            ),
            ListTile(
              title: Text("Alerts",
                  style: _active2? _activeone(): _notactive()),
              leading: Icon(
                  Icons.notifications_active
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => prime()), (route) => false);
              },
            ),
            ListTile(
              title: Text("Reports",
                  style: _active3? _activeone(): _notactive()),
              leading: Icon(
                Icons.show_chart,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("Suspects",
                  style: _active4? _activeone(): _notactive()),
              leading: Icon(
                Icons.accessibility,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("Objects",
                  style: _active5? _activeone(): _notactive()),
              leading: Icon(
                Icons.dangerous_sharp,
              ),
              onTap: () {},
            ),
            ListTile(
              title: Text("Settings",
                  style: _active6? _activeone(): _notactive()),
              leading: Icon(
                Icons.settings,
              ),
              onTap: () {
                setState(() {
                  _active= false;
                  _active2 = false;
                  _active3 = false;
                  _active4 = false;
                  _active5 = false;
                  _active6 = true;
                  _active7 = false;
                });
                Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => SettingsParent()), (route) => false);
              },
            ),
            ListTile(
              title: Text("Help",
                style: _active7? _activeone(): _notactive(),
              ),
              leading: Icon(
                Icons.help,
              ),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}
