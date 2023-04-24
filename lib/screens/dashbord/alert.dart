import 'dart:async';

import 'package:admin/falsealertparent.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:local_auth/local_auth.dart';
import '../../databaseconnection.dart';
import '../../demo.dart';
import '../../firebase_options.dart';
import 'components/header.dart';
import 'package:admin/constants.dart';
import 'package:quiver/async.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Alert extends StatefulWidget {
  const Alert({Key? key}) : super(key: key);

  @override
  State<Alert> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Alert> {
  late DatabaseReference db;
  final LocalAuthentication auth = LocalAuthentication();
  String authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> authenticateFalseAlert(String alert) async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'To truly identify ',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
            () => authorized = authenticated ? 'Authorized' : 'Not Authorized');
    print(authorized);
    if (authorized == 'Authorized') {
      await Services.setAlertToFalse(alert).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            Demo(builder: (BuildContext context) => FalseAlertParent()),
                (route) => false);
      });

    }
  }

  Future<void> initiateFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).whenComplete(() {
      print("completed");
      setState(() {
        db = FirebaseDatabase.instance.ref("messages/2022");
      });
      db.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        final json = data as Map;
        setState(() async {
          String connection = json['message']['connection'];
          if(connection == 'plus'){
            await Noti.showBigTextNotification(title: 'Notice', body: 'A New Alert Has Occured', fln: flutterLocalNotificationsPlugin);
          }

        });
        print(data);
      });
    });
  }

  int counter = 1;
   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Noti.intitialize(flutterLocalNotificationsPlugin);
    initiateFirebase();
    listentoAlerts();
  }
  
  Future<void> listentoAlerts() async {
     while(counter > 0){
      await Future.delayed(Duration(seconds: 1)).then((value) {
         handleAlerts();
       });
     }
     counter++;
  }

  late Timer _timer;
  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (Services.start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            Services.start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void handleAlerts(){
    for(var alert in Services.motionalerts){
      DataRow dr = DataRow(cells: [
        DataCell(Text(alert.alert_id)),
        DataCell(Text(alert.date)),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence One"),
                  content: Image.network(alert.imageone),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 1'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence Two"),
                  content: Image.network(alert.imagetwo),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 2'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
             await authenticateFalseAlert(alert.alert_id.toString());
             await Noti.showBigTextNotification(title: 'Notice', body: 'False Alarm Sent', fln: flutterLocalNotificationsPlugin);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('False Alert'),
                  Icon(
                      Icons.back_hand
                  )
                ],
              ),
            )))
      ]);
      Services.motionrows.add(dr);

    }

    for(var alert in Services.objectalerts){
      DataRow dr = DataRow(cells: [
        DataCell(Text(alert.alert_id)),
        DataCell(Text(alert.date)),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence One"),
                  content: Image.network(alert.imageone),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 1'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence Two"),
                  content: Image.network(alert.imagetwo),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 2'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              //authenticateuser and uodate to false alert
              await authenticateFalseAlert(alert.alert_id.toString());
              await Noti.showBigTextNotification(title: 'Notice', body: 'False Alarm Sent', fln: flutterLocalNotificationsPlugin);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('False Alert'),
                  Icon(
                      Icons.back_hand
                  )
                ],
              ),
            )))
      ]);
      Services.objectrows.add(dr);
    }

    for(var alert in Services.criminalalerts){
      DataRow dr = DataRow(cells: [
        DataCell(Text(alert.alert_id)),
        DataCell(Text(alert.date)),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence One"),
                  content: Image.network(alert.imageone),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 1'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              showDialog(context: context, builder: (ctx) {
                return AlertDialog(
                  title: const Text("Evidence Two"),
                  content: Image.network(alert.imagetwo),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: Text('Close me'))
                  ],
                );
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('Picture 2'),
                  Icon(
                      Icons.photo_library_sharp
                  )
                ],
              ),
            ))),
        DataCell(ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<
                    RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            18.0),
                        side: BorderSide(
                            color:
                            Colors.white)))),
            onPressed: () async {
              //authenticateuser and uodate to false alert
              await authenticateFalseAlert(alert.alert_id.toString());
              await Noti.showBigTextNotification(title: 'Notice', body: 'False Alarm Sent', fln: flutterLocalNotificationsPlugin);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Text('False Alert'),
                  Icon(
                      Icons.back_hand
                  )
                ],
              ),
            )))
      ]);
      Services.criminalrows.add(dr);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Alerts",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Header(),
              ),
              const SizedBox(height: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Text("Motion Detections"),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text('Alert ID'),
                                    ),
                                    DataColumn(
                                      label: Text('Date'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence One'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence Two'),
                                    ),
                                    DataColumn(
                                      label: Text('Action'),
                                    )
                                  ],
                                  rows: Services.motionrows,
                                ))
                          ],
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Text("Object Detections"),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text('Alert ID'),
                                    ),
                                    DataColumn(
                                      label: Text('Date'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence One'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence Two'),
                                    ),
                                    DataColumn(
                                      label: Text('Action'),
                                    )
                                  ],
                                  rows: Services.objectrows,
                                ))
                          ],
                        )),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(defaultPadding),
                    decoration: const BoxDecoration(
                      color: secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Text("Criminal Detections"),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: [
                                    DataColumn(
                                      label: Text('Alert ID'),
                                    ),
                                    DataColumn(
                                      label: Text('Date'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence One'),
                                    ),
                                    DataColumn(
                                      label: Text('Evidence Two'),
                                    ),
                                    DataColumn(
                                      label: Text('Action'),
                                    )
                                  ],
                                  rows: Services.criminalrows,
                                ))
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ), //Entire app is an a column so therefore inside is a series of rows
        ),
      ),
    );
  }
}
