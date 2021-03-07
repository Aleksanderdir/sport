import 'package:flutter/material.dart';
import 'package:pulse_gym/screens/auth.dart';
import 'package:pulse_gym/screens/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = true;
    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
