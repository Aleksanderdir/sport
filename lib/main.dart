import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_gym/domain/user.dart';
import 'package:pulse_gym/screens/landing.dart';
import 'package:pulse_gym/services/auth.dart';

import 'domain/user.dart';

void main() => runApp(MaxfitApp());

class MaxfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().currentUser,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pulse Gym',
          theme: ThemeData(
              primaryColor: Color.fromRGBO(50, 65, 85, 1),
              textTheme: TextTheme(title: TextStyle(color: Colors.white))),
          home: LandingPage()),
    );
  }
}
//}
