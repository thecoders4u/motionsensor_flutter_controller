import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'components/header.dart';
import 'package:admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'components/monitordata.dart';

class MonitorScreen extends StatefulWidget {
  const MonitorScreen({Key? key}) : super(key: key);

  @override
  State<MonitorScreen> createState() => _MonitorScreenState();
}

class _MonitorScreenState extends State<MonitorScreen> {
  late DatabaseReference _databaseReference;
  @override
  initState(){
    // TODO: implement initState
    super.initState();
   initiateFirebase();
  }

  Future<void> initiateFirebase() async{
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
  String? _email;
  TextEditingController message = TextEditingController();

  Widget _buildEmail(){
    return TextFormField(

      controller: message,
      decoration:  InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),

        filled: true,
        icon: Icon(Icons.send,
          color: Colors.blue,),
        hintText: 'Message',
        labelText: 'Msg',
        labelStyle: TextStyle(
          color: Colors.blue,

        ),

      ),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String? value) {
        this._email = value;
        print('email=$_email');
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Monitor",
          style: TextStyle(
            color: Colors.blue,
          ),),
        backgroundColor: Colors.white,
      ),
      body: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(defaultPadding),
            decoration: const BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: EdgeInsets.all(24),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: defaultPadding),
                      child: Header(),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            children: [

                              const SizedBox(height: defaultPadding),
                              const RecentFiels(),
                              const SizedBox(height: defaultPadding),
                              _buildEmail(),
                              ElevatedButton(
                                  style: ButtonStyle(

                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                              side: BorderSide(color: Colors.white)
                                          )
                                      )
                                  ),
                                  onPressed: () async{

                                    await _databaseReference.set({
                                      "message": message.text,

                                    }).whenComplete(() => print("done"));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Sent'),
                                        duration: Duration(seconds: 5),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: const Text(
                                        'Send',
                                        style: TextStyle(color: Colors.white, fontSize: 16)),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
