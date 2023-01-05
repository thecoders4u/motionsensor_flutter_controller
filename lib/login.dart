import 'dart:async';
import 'package:admin/databaseconnection.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin/constants.dart';
import 'package:local_auth/local_auth.dart';
import 'package:admin/demo.dart';
import 'package:admin/homeparent.dart';
import 'package:admin/demo.dart';
import 'package:admin/register.dart';
import 'allclasses.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class LoginScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _TextFormFieldExampleState();
}

// Adapted from the text form demo in official gallery app:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/text_form_field_demo.dart
class _TextFormFieldExampleState extends State<LoginScreen> {
  //Biometrics
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  bool? _canCheckBiometrics;
  List<BiometricType>? _availableBiometrics;
  String authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  static late List<Customer> currentCustomer = [];
  @override
  void initState() {
    super.initState();

    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> authenticate() async {
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
    if(authorized == 'Authorized'){
      Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => HomeParent()), (route) => false);
    }

  }

  Future<void> _authenticateWithBiometrics() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason:
        'Scan your fingerprint (or face or whatever) to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
        authorized = 'Authenticating';
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

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      authorized = message;
    });
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }




  //Form Parts
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
  GlobalKey<FormFieldState<String>>();

  String? _email;
  String? _password;


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
        labelText: 'E-mail',
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
  Widget _buildPass(TextEditingController txt){
    return PasswordField(
      txtController:  txt,
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
        builder: (context) {
          return Container(
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
                        Icon(Icons.login,
                          size: 90,
                          color: Colors.blue,
                        ),
                        Text("Welcome Dear,Kindly Login",
                            style: TextStyle(color: Colors.blue,)),
                        const SizedBox(height: 24.0),
                        _buildEmail(),
                        const SizedBox(height: 24.0),
                        _buildPass(pass),
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
                              _formkey.currentState!.save();
                              await Services.logCustomer(email.text, pass.text).then((value)
                                {
                                  setState(() {
                                    currentCustomer = value;
                                   print(currentCustomer);
                                    if(currentCustomer.isNotEmpty){
                                      authenticate();
                                    }
                                    else{
                                      ScaffoldMessenger.of(context).showSnackBar(
                                         SnackBar(
                                          content: Text('Incorrect Credentials or '
                                              'Please Check your Internet Connection'),
                                          duration: Duration(seconds: 5),
                                        ),
                                      );
                                    }
                                  });
                                }
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: const Text(
                                  'Login',
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            )),
                        const SizedBox(height: 24.0),
                        InkWell(
                          onTap: () =>  Navigator.pushAndRemoveUntil(context, Demo(builder: (BuildContext context) => RegisterScreen()), (route) => false),
                          child: Text(
                            'Don"t have an Account?',
                            style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),// "Re-type password" form.,
                ],
              ),
            ),
          );
        }
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