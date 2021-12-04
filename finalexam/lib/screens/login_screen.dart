
import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:finalexam/Models/token.dart';
import 'package:finalexam/components/loader_component.dart';
import 'package:finalexam/helpers/constans.dart';
import 'package:finalexam/screens/form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
   String _email ='zulu@yopmail.com';
   String _emailError ='';
   bool _emailShowError = false;
   String _password ='';
   String _passwordError ='123456';
   bool _passwordShowError = false;
   bool _remenberme = true;
   bool _passwordshow = false;
   bool _showLoader = false;
   bool _rememberme = true;
   
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40,),
                _showLogo(),
                SizedBox(height: 20,),
                _showButtons(),
              ],
            ),
            
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere...',) : Container(),
        ],
      ),
      backgroundColor: Colors.pink.shade50,
    );
  }

   Widget _showLogo() {
    return Image(
      image: AssetImage('assets/logo.png'),
      width: 300,
      fit: BoxFit.fill,
    );
  }

Widget _showButtons() {
  return Container(
    margin: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      children: [
        
         _showGoogleLoginButton(),
      ],
    ),
    
  );
  
}
  Widget _showGoogleLoginButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _loginGoogle(), 
            icon: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.red,
            ), 
            label: Text('Iniciar sesión con Google'),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black
            )
          )
        )
      ],
    );
  }

  _loginGoogle() async {
    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    var user = await googleSignIn.signIn();
    
     Map<String, dynamic> request = {
      'email': user?.email,
      'id': user?.id,
      'loginType': 1,
      'fullName': user?.displayName,
      'photoURL': user?.photoUrl,
    };

       await _socialLogin(request);
  }
  
   Future _socialLogin(Map<String, dynamic> request) async {

     var url = Uri.parse('${Constans.apiUrl}/api/Account/SocialLogin');
    var bodyRequest = jsonEncode(request);
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
      },
      body: bodyRequest,
    );

    setState(() {
      _showLoader = false;
    });
    if(response.statusCode >= 400) {
      await showAlertDialog(
        context: context,
        title: 'Error', 
        message: 'El usuario ya inció sesión previamente por email o por otra red social.',
        actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
        ]
      );    
      return;
    }

    var body = response.body;

    if (_rememberme) {
      _storeUser(body);
    }
var decodedJson = jsonDecode(body);
    var token = Token.fromJson(decodedJson);
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => FormScreen()
      )
    );

   }
     void _storeUser(String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRemembered', true);
    await prefs.setString('userBody', body);
  }
  
}