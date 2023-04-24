import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'components/header.dart';
import 'package:admin/constants.dart';


class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
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
                          children: const <Widget>[
                            Text("How to Start the System?",
                            style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('To Start the System, you must first make sure that '
                                'you are logged in,'
                                'You must make sure you must the degreecam installed on your seperate android device and launch it '
                                ' from there click the hamburger menu and click on monitor'
                            'from there you will be able to selet the options to start the system and click start'),

                            Text("What are the Modes of Operating the System?",
                              style: TextStyle(fontWeight: FontWeight.bold),),
                            Text('1. Motion Detection'),
                            Text('This means that the system will run only to detect motion in the environment'),
                            Text('2. Object Detection'),
                            Text('This means that the system will run only to two objects, guns and knives strictly'),
                            Text('3. Criminal Detection'),
                            Text('This means that the system will run only to detect a crriminal (by faces)'),

                            Text('What do i do in the system?',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('1. Run the Detection through the mobile app on your phone and the camera app on another device'),
                            Text('2. Check your alerts from your environment'),
                            Text('3. Schedule the system to run at your own time intervals and days as well'),
                            Text('4. Send a false alert by ')
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
