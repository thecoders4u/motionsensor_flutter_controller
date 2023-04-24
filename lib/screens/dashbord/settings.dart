import 'package:admin/allclasses.dart';
import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'components/header.dart';
import 'components/settingsdata.dart';
import 'package:admin/databaseconnection.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  static late List<UserSettings> usersettings = [];
  bool isSwitched = false;
  var textValue = '';

  late String daysetting = '';
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('on');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('off');
    }
  }

  var values = List.filled(7, true);
  int val = 1;
  late String customerid = '';
  late String days = '';
  late TextEditingController timeController = TextEditingController();
  late TextEditingController timeController2 = TextEditingController();

  late TextEditingController contactController = TextEditingController();
  late TextEditingController contactController2 = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getSettings() async {
    await Services.getUserSettings().then((value) {
      Services.allsettings = value;
      customerid = Services.realcustomer.first.customer_id;
      for (var customerSetting in Services.allsettings) {
        print('hi');
        if (customerSetting.customer_id == customerid) { //make sure to set the default configurations in the5miles.com phpmyadmin
          Services.currentsettings['customerid'] = customerSetting.customer_id;
          Services.currentsettings['active_days'] = customerSetting.active_days;
          Services.currentsettings['camerasensitivity'] =
              customerSetting.camera_level as int;
          Services.currentsettings['start_time'] = customerSetting.start_time;
          Services.currentsettings['end_time'] = customerSetting.end_time;

          setState(() {

            contactController.text = Services.currentsettings['contact1'] as String;
            contactController2.text = Services.currentsettings['contact2'] as String;

            timeController.text = Services.currentsettings['start_time'] as String;
            timeController2.text = Services.currentsettings['end_time'] as String;
            values = Services.currentsettings['active_days'] as List<bool>;
            val = Services.currentsettings['camerasensitivity'];




            /**
                final split = days.split(',');
                final Map<dynamic, dynamic> settingsmap = {
                for (int i = 0; i < split.length; i++) {i: split[i]}
                } as Map;
                values() => settingsmap.entries.map((e) => e.value).toList();
             **/


          });
          break;
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Settings",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.mic,
                  color: Colors.redAccent,
                  size: 30,
                ),
                Icon(
                    Icons.help,
                    color: Colors.redAccent,
                    size: 30
                )
              ],
            )
          ],
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
                    height: 700,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: Column(
                        children: <Widget>[
                          Text("Night Mode:"),
                          Row(
                            children: [
                              Text('Dark Theme'),
                              Switch(
                                value: isSwitched,
                                onChanged: toggleSwitch,
                                activeColor: Colors.red,
                                activeTrackColor: Colors.red,
                                inactiveTrackColor: Colors.black,
                              ),
                            ],
                          ),
                          Text("Start Schedule Time:"),
                          TextField(

                            readOnly: true,
                            controller: timeController,
                            decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                                ),
                                hintStyle: TextStyle(color: Colors.redAccent),
                                hintText: 'Tap me for your start time'),
                            onTap: () async {
                              var time = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              // ignore: unnecessary_null_comparison
                              if (time != null) {
                                await time.then((value) {
                                  timeController.text = value!.format(context);
                                });
                              }
                            },
                          ),
                          Text("End Schedule Time:"),
                          TextField(
                            readOnly: true,
                            controller: timeController2,
                            decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                                ),
                                hintStyle: TextStyle(color: Colors.redAccent),
                                hintText: 'Tap me for your end time'),
                            onTap: () async {
                              var time = showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now());
                              // ignore: unnecessary_null_comparison
                              if (time != null) {
                                await time.then((value) {
                                  timeController2.text = value!.format(context);
                                });
                              }
                            },
                          ),
                          Text("First Contact: (Start With +265)*"),
                          TextField(
                            readOnly: true,
                            controller: contactController,
                            decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                                ),
                                hintStyle: TextStyle(color: Colors.redAccent),
                                hintText: 'Insert Your First Contact'),

                          ),
                          Text("Second Contact: (Start With +265)*"),
                          TextField(
                            readOnly: true,
                            controller: contactController2,
                            decoration: const InputDecoration(
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
                                ),
                                hintStyle: TextStyle(color: Colors.redAccent),
                                hintText: 'Insert Your Second Contact'),
                          ),
                          Text('Chosen Active Days:'),
                          WeekdaySelector(
                              color: Colors.white,
                              selectedFillColor: Colors.redAccent,
                              disabledFillColor: Colors.black,
                              onChanged: (int day) {
                                setState(() {
                                  final index = day % 7;
                                  values[index] = !values[index];
                                });
                              },
                              values: values),
                          Text('Camera Sensitivity:'),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text("Low"),
                                leading: Radio(
                                  groupValue: val,
                                  value: 1,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value as int;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                              ),
                              ListTile(
                                title: Text("Medium"),
                                leading: Radio(
                                  groupValue: val,
                                  value: 2,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value as int;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                              ),
                              ListTile(
                                title: Text("High"),
                                leading: Radio(
                                  groupValue: val,
                                  value: 3,
                                  onChanged: (value) {
                                    setState(() {
                                      val = value as int;
                                    });
                                  },
                                  activeColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: BorderSide(
                                              color: Colors.white))),
                                backgroundColor: MaterialStateProperty.all(Colors.red),),
                              onPressed: () async {
                                Services.currentsettings['camera_sensitivity'] = val;
                                Services.currentsettings['start_time'] = timeController.text;
                                Services.currentsettings['end_time'] = timeController2.text;
                                Services.currentsettings['active_days'] = values.toString();
                                Services.currentsettings['customer_id'] = customerid;
                                Services.currentsettings['contact1'] = contactController.text;
                                Services.currentsettings['contact2'] = contactController2.text;
                                Services.currentsettings['action'] = Services.SAVE_SETTINGS;


                                Services.saveSettings(Services.currentsettings).then((value) {
                                  print(value);
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: const Text('Save Settings',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16)),
                              ))
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
