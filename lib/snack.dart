import 'package:flutter/material.dart';

class test extends StatelessWidget {
  const test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: prime(),
    );
  }
}

class prime extends StatefulWidget {
  const prime({Key? key}) : super(key: key);

  @override
  State<prime> createState() => _primeState();
}

class _primeState extends State<prime> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(

        builder: (context) => FlatButton(
          child: Text('Text'),
          onPressed: (){
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Echo Mr Ceekay'),
              ),
            );
          },
        ),
      ),
    );
  }
}

