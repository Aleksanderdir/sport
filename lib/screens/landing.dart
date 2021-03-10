import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulse_gym/domain/user.dart';
import 'package:pulse_gym/screens/auth.dart';
import 'package:pulse_gym/screens/home.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context);
    final bool isLoggedIn = user != null;
    return isLoggedIn ? HomePage() : AuthorizationPage();
  }
}
