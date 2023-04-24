import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../../databaseconnection.dart';
import '../../firebase_options.dart';
import 'components/header.dart';
import 'package:admin/constants.dart';

class FalseAlert extends StatefulWidget {
  const FalseAlert({Key? key}) : super(key: key);

  @override
  State<FalseAlert> createState() => _FalseAlertState();
}

class _FalseAlertState extends State<FalseAlert> {

  int counter = 0;
  late DatabaseReference _databaseReference;
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

        print(data);
      });
    });
  }

  Future<void> listentoAlerts() async {
    while(counter > 0){
      await Future.delayed(Duration(seconds: 1)).then((value) {
        handleAlerts();
      });
    }
    counter++;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listentoAlerts();
  }
  void handleAlerts(){
    for(var alert in Services.falsealerts){
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
            )))
      ]);
      Services.motionrows.add(dr);

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "False Alerts",
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
                            Text("False Alerts"),
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
                                      label: Text('Evidence 1'),
                                    ),
                                    DataColumn(label: Text('Evidence 2')),
                                  ],
                                  rows: Services.falserows,
                                ))
                          ],
                        )),
                  )
                ],
              ),
            ],
          ), //Entire app is an a column so therefore inside is a series of rows
        ),
      ),
    );
  }
}
