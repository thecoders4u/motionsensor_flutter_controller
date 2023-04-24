import 'dart:io';

import 'package:admin/allclasses.dart';
import 'package:admin/constants.dart';
import 'package:admin/databaseconnection.dart';
import 'package:admin/responsive.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../databaseconnection.dart';
import 'components/header.dart';
import 'package:admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/monitordata.dart';
import 'dart:convert';
import 'noti.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late DatabaseReference _databaseReference;
  int doorval = 0;
  bool doorlocked = false;

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    Noti.intitialize(flutterLocalNotificationsPlugin);
    initiateFirebase();
    setMessages();
  }
  void setMessages(){
    Services.cameramessages['criminal'] = 'no';
    Services.cameramessages['motion'] = 'no';
    Services.cameramessages['object'] = 'no';
    Services.cameramessages['door'] = 'unlocked';
    Services.cameramessages['connection'] = 'connected';
    Services.cameramessages['customer_id'] = Services.realcustomer.first.customer_id;
    Services.cameramessages['customer_phone'] = Services.realcustomer.first.customer_phone;
    Services.cameramessages['customer_name'] = Services.realcustomer.first.customer_name;

  }

  Future<void> initiateFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ).whenComplete(() {
      print("completed");
      setState(() {
        _databaseReference = FirebaseDatabase.instance.ref("messages/2022");
      });
      _databaseReference.onValue.listen((DatabaseEvent event) {
        final data = event.snapshot.value;
        final json = data as Map;
        setState(() async {
          String connection = json['message']['connection'];
          String door = json['message']['door'];
          if(connection == 'plus'){
            await Noti.showBigTextNotification(title: 'Notice', body: 'A New Alert Has Occured', fln: flutterLocalNotificationsPlugin);
            auto = false;
            if(door == 'unlocked'){
              doorlocked = false;
            }
            else if(door == 'locked'){
              doorlocked = true;
            }
          }
          else{
            if(door == 'unlocked'){
              doorlocked = false;
            }
            else if(door == 'locked'){
              doorlocked = true;
            }
          }
        });
        print(data);
      });
    });
  }


  TextEditingController message = TextEditingController();
  bool auto = true;
  bool innerauto = true;
  bool motion = true;
  bool object = false;
  bool criminal = false;
  bool useSettings = false;

  int val = -1;
  int val2 = 2;
  Widget _doorHandler(){
    return Column(
      children: [
        Text('Control Your Door(Optional)',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            )),

        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)))),
            onPressed: () async {
              setState(() {
                Map<String, dynamic> doormap = {};

                if(doorlocked){
                  doormap['door'] = 'locked';
                  doormap['connection'] = 'blank';
                }
                else if(!doorlocked){
                  doormap['door'] = 'locked';
                  doormap['connection'] = 'blank';
                }

              });
              await _databaseReference.set({
                "message": Services.cameramessages,
              }).whenComplete(() => print("success"));
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: !doorlocked ? const Text('Lock Door',
                  style: TextStyle(color: Colors.white, fontSize: 16)): const Text('Unlock Door',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ))
      ],

    );

  }



  Widget _returnWorking(){
    return Column(
      children: [
      Text('Camera is Now Operating, Relax while we take control',
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
      )),
        SpinKitPianoWave(
          color: Colors.red,
          size: 100.0,
        ),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)))),
            onPressed: () async {
              setState(() {
                Services.cameramessages['connection'] = 'end';
              });
              await _databaseReference.set({
                "message": Services.cameramessages,
              }).whenComplete(() => print("success"));
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Stop System',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ))
      ],

    );

  }
  Widget _returnAutomatic() {
    return Column(children: [
      Text('Use Your Current System Settings:',
    style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
    )),
      ListTile(
        title: Text("Yes"),
        leading: Radio(
          groupValue: val2,
          value: 1,
          onChanged: (value) {
            setState(() {
              val2 = value as int;
              innerauto = true;
              useSettings = true;
            });
          },
          activeColor: Colors.red,
        ),
      ),
      ListTile(
        title: Text("No"),
        leading: Radio(
          groupValue: val2,
          value: 2,
          onChanged: (value) {
            setState(() {
              val2 = value as int;
              innerauto = false;
              useSettings = false;
            });
          },
          activeColor: Colors.red,
        ),
      ),
      Text('Select your preferences ',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold
      ),),
      Text(
          '* NOTICE: Criminal-Detection only works alone'
      ),

      ListTile(
        title: Text("Motion-Detection"),
        leading: Checkbox(
          value: motion,
          onChanged: (value) {
            setState(() {
              if (motion) {
                motion = false;
                Services.cameramessages['motion'] = 'no';
              } else {
                if (criminal) {
                  motion = false;
                } else {
                  motion = true;
                  Services.cameramessages['motion'] = 'yes';
                }
              }
            });
          },
          activeColor: Colors.red,
        ),
      ),
      ListTile(
        title: Text("Object-Detection"),
        leading: Checkbox(
          value: object,
          onChanged: (value) {
            setState(() {
              if (object) {
                object = false;
                Services.cameramessages['object'] = 'no';
              } else {
                if (criminal) {
                  object = false;
                } else {
                  object = true;
                  Services.cameramessages['object'] = 'yes';
                }
              }
            });
          },
          activeColor: Colors.red,
        ),
      ),
      ListTile(
        title: Text("Criminal-Detection"),
        leading: Checkbox(
          value: criminal,
          onChanged: (value) {
            setState(() {
              if (criminal) {
                criminal = false;
                Services.cameramessages['criminal'] = 'no';
              } else {
                if (motion || object) {
                  criminal = false;
                } else {
                  criminal = true;
                  Services.cameramessages['criminal'] = 'yes';
                }
              }
            });
          },
          activeColor: Colors.red,
        ),
      ),
      ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.white)))),
          onPressed: () async {
            setState(() {
           //   Services.cameramessages['settings_mode'] = useSettings;
            //  Services.cameramessages['days'] = Services.currentsettings['active_days'];
          //    Services.cameramessages['camera_sensitivity'] = Services.currentsettings['camerasensitivity'];
          //    Services.cameramessages['start_time'] = Services.currentsettings['start_time'];
           //   Services.cameramessages['end_time'] = Services.currentsettings['end_time'];

            Services.cameramessages['customer_id'] = Services.realcustomer.first.customer_id;
            Services.cameramessages['customer_name'] = Services.realcustomer.first.customer_name;
            Services.cameramessages['customer_phone'] = Services.realcustomer.first.customer_phone;


            });
            await _databaseReference.set({
              "message": Services.cameramessages,
            }).whenComplete(() {
              print("success");
              setState(() {
                auto = false;
              });
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: const Text('Start System',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ))
    ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Monitor",
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: Header(),
              ),
              const SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(defaultPadding),
                decoration: const BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: Column(
                        children: <Widget>[
                          auto? _returnAutomatic() : _returnWorking(),
                          _doorHandler()
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
