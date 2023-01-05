import 'dart:convert';


import 'package:admin/allclasses.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin/constants.dart';
import 'package:admin/login.dart';
import 'package:admin/demo.dart';
import 'databaseconnection.dart';
class RegisterScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TextFormFieldExampleState();
}

// Adapted from the text form demo in official gallery app:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart
class _TextFormFieldExampleState extends State<RegisterScreen> {


  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController info = TextEditingController();

  static late int loc_id = 0;

  late String _regVal = '';
  late String _disVal = '';
  late String _areaVal = '';
  late List<DefaultPlace> locations = [];
  late List<DropdownMenuItem<String>> _regionList = [];
  late List<DropdownMenuItem<String>> _districtList = [];
  late List<String> _tempy = [];

  late List<DropdownMenuItem<String>> _areaList = [];
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();




  String? _name;
  String? _phoneNumber;
  String? _email;
  String? _password;
  String? _street;
  String? _info;

  String? _validateName(String? value) {
    if (value?.isEmpty ?? false) {
      return 'Name is required.';
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }
  static const menuItems = <String>[
    'One',
    'Two',
    'Three',
    'Four',
  ];


 void startPlaces() async{
   await Services.getsetPlaces('', '').then((value){
     setState(() {
       locations = value;
     });
   });

   _regionList = locations.map((DefaultPlace place) => DropdownMenuItem<String>(
     child: Text(place.region_name.toString()),
     value: place.region_name.toString(),
   )).toSet().toList();
   print(_regionList);
   _tempy.clear();
   for (var elements in _regionList) {
     _tempy.add(elements.value.toString());
   }
   _tempy = _tempy.toSet().toList();
   _regionList.clear();
   _regionList = _tempy.map((String str) => DropdownMenuItem<String>(
     value: str,
     child: Text(str),
   )).toList();
   print(_tempy.toSet().toList());
 }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    startPlaces();
    print(menuItems);


  }
  void _setDistricts(String region) async{

  await Services.getsetPlaces(region, '').then((value){
      print(value);
      setState(() {
        locations = value;
      });
    });

  _districtList = locations.map((DefaultPlace place) => DropdownMenuItem<String>(
    child: Text(place.district_name.toString()),
    value: place.district_name.toString(),
  )).toSet().toList();
  print(_districtList);
  _tempy.clear();
  for (var elements in _districtList) {
    _tempy.add(elements.value.toString());
  }
  _tempy = _tempy.toSet().toList();
  _districtList.clear();
  _districtList = _tempy.map((String str) => DropdownMenuItem<String>(
    value: str,
    child: Text(str),
  )).toList();
  print(_tempy.toSet().toList());
  }

  void _setAreas(String district) async{
    await Services.getsetPlaces('', district).then((value){
      print(value);
      setState(() {
        locations = value;

      });
    });
    _areaList = locations.map((DefaultPlace place) => DropdownMenuItem<String>(
      child: Text(place.area_name.toString()),
      value: place.area_name.toString(),
    )).toSet().toList();
    print(_areaList);
    _tempy.clear();
    for (var elements in _areaList) {
      _tempy.add(elements.value.toString());
    }
    _tempy = _tempy.toSet().toList();
    _areaList.clear();
    _areaList = _tempy.map((String str) => DropdownMenuItem<String>(
      value: str,
      child: Text(str),
    )).toList();
    print(_tempy.toSet().toList());
  }
  Widget _buildName(){
    return TextFormField(
      controller: name,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),

        filled: true,
        icon: Icon(Icons.person,
        color: Colors.blue),
        hintText: 'What do people call you?',
        labelText: 'Name *',
        labelStyle: TextStyle(
          color: Colors.blue,
        )
      ),
      onSaved: (String? value) {
        this._name = value;
        print('name=$_name');
      },
      validator: _validateName,
    );
  }

  Widget _buildStreet(){
    return TextFormField(
      controller: street,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),

          filled: true,
          icon: Icon(Icons.add_road,
              color: Colors.blue),
          hintText: 'Street of House/Office (e.g Victoria Avenue)?',
          hintStyle: TextStyle(
            color: Colors.blue,
          ),
          labelText: 'Street',
          labelStyle: TextStyle(
            color: Colors.blue,
          )
      ),
      onSaved: (String? value) {
        this._street = value;
        print('street=$_street');
      },
    );
  }
  Widget _buildInfo(){
    return TextFormField(
      controller: info,
      textCapitalization: TextCapitalization.words,
      decoration: const InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),

          filled: true,
          icon: Icon(Icons.house_rounded,
              color: Colors.blue),
          hintText: 'House Info/Building Info (e.g House No 5/Building 10)',
          hintStyle: TextStyle(
            color: Colors.blue,
          ),
          labelText: 'Street',
          labelStyle: TextStyle(
            color: Colors.blue,
          )
      ),
      onSaved: (String? value) {
        this._info = value;
        print('info=$_info');
      },
    );
  }
  Widget _buildPhone(){
    return  TextFormField(
      controller: phone,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),

        filled: true,
        icon: Icon(Icons.phone,
        color: Colors.blue),
        hintText: 'Where can we reach you?',
        labelText: 'Phone Number *',
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        prefixText: '+265 ',
        prefixStyle: TextStyle(
          color: Colors.blue,
        )
      ),
      keyboardType: TextInputType.phone,
      onSaved: (String? value) {
        this._phoneNumber = value;
        print('phoneNumber=$_phoneNumber');
      },
      // TextInputFormatters are applied in sequence.
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
    );
  }
  Widget _buildEmail(){
    return TextFormField(

      controller: email,
      decoration:  InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),

        filled: true,
        icon: Icon(Icons.email,
        color: Colors.blue,),
        hintText: 'Your email address',
        labelText: 'E-mail *',
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


  Widget _buildRegions() => ListTile(
    title: const Text('Region:',
    style: TextStyle(color: Colors.blue),),

    trailing: DropdownButton<String>(

      items: this._regionList,
      onChanged: (String? newValue) => setState(() {
        _regVal = newValue!;
        _setDistricts(newValue);
      }),
    ),

  );
  Widget _buildDistricts() => ListTile(
    title: const Text('District:',
      style: TextStyle(color: Colors.blue),),
    trailing: DropdownButton<String>(
      items: this._districtList,
      onChanged: (String? newValue) => setState(() {
        _disVal = newValue!;
        print(_disVal);
        _setAreas(newValue);
      }),
    ),

  );
  Widget _buildAreas() => ListTile(
    title: const Text('Area:',
      style: TextStyle(color: Colors.blue),),
    trailing: DropdownButton<String>(
      items: this._areaList,
      onChanged: (String? newValue) => setState(() {
        _areaVal = newValue!;
        for(var item in locations){
          print('hi');
          if(item.region_name == _regVal && item.district_name == _disVal && item.area_name == _areaVal){
            loc_id = int.parse(item.location_id);
            print(loc_id);
            break;
          }

        }
      }),
    ),

  );
  Widget _buildPass(TextEditingController txt){
    return PasswordField(

      fieldKey: _passwordFieldKey,
      helperText: 'No more than 8 characters.',
      labelText: 'Password *',
      onSaved: (String? value) {
      this._password = value;
      print('password=$_password');
    },
      onFieldSubmitted: (String value) {
        setState(() {
          this._password = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Container(
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          margin: EdgeInsets.all(24),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.app_registration,
                        size: 90,
                        color: Colors.blue,
                      ),
                      Text("Welcome, Please Sign Up",
                      style: TextStyle(color: Colors.blue,)),
                      const SizedBox(height: 24.0),
                      _buildName(),
                      const SizedBox(height: 24.0),
                      _buildEmail(),
                      const SizedBox(height: 24.0),
                      _buildPhone(),
                      const SizedBox(height: 24.0),
                      _buildPass(pass),
                      const SizedBox(height: 24.0),
                      Text("Select your Region",
                          style: TextStyle(color: Colors.blue,)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          _buildRegions(),
                          _buildDistricts(),
                          _buildAreas()
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      _buildStreet(),
                      const SizedBox(height: 24.0),
                      _buildInfo(),
                      const SizedBox(height: 24.0),
                      ElevatedButton(
                         style: ButtonStyle(
                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                 RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(18.0),
                                     side: BorderSide(color: Colors.white)
                                 )
                             )
                         ),
                          onPressed: () async {


                            _formkey.currentState!.save();
                            print(_regVal);
                            print(_disVal);
                            print(_areaVal);
                            print(loc_id);
                            print(pass.text);
                            print(phone.text);
                            await Services.addCustomer(name.text, phone.text, loc_id, street.text, info.text, _password!, email.text).then(
                                     (value){
                                      print(value);
                                      if(value.length > 50){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Well done!'),
                                            duration: Duration(seconds: 5),
                                            onVisible: () {
                                              Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => LoginScreen()), (route) => false);
                                            },
                                          ),
                                        );
                                      }
                                      else{
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Failed to register you, Check your Internet '
                                                'Connection and Fill all Necessary Fields'),
                                          ),
                                        );
                                      }
                                     });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: const Text(
                                'Register',
                                style: TextStyle(color: Colors.white, fontSize: 16)),
                          )),
                      const SizedBox(height: 24.0),
                      InkWell(
                        onTap: () =>  Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => LoginScreen()), (route) => false),
                        child: const Text(
                          'Already Have an Account?',
                          style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                        ),
                      )
                    ],
                  ),
                ),// "Re-type password" form.,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.txtController,
     });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final TextEditingController? txtController;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.txtController,
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        icon: Icon(Icons.lock,
        color: Colors.blue,),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),

        filled: true,
        labelStyle: TextStyle(
          color: Colors.blue,
        ),
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}