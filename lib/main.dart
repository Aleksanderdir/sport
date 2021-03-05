import 'package:flutter/material.dart';

import 'screens/home.dart';

void main() => runApp(MaxfitApp());

class MaxfitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Color.fromRGBO(50, 65, 85, 1),
            textTheme: TextTheme(title: TextStyle(color: Colors.white))),
        home: HomePage());
  }
}
//}
