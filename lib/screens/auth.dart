
import 'package:flutter/material.dart';
 class AuthorizationPage extends StatefulWidget {
   AuthorizationPage({Key key}) : super(key: key);

   @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
 }
  class _AuthorizationPageState extends State<AuthorizationPage>{
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Theme.of(context).primaryColor ,
       body: Text('Auth')

     );
  }

