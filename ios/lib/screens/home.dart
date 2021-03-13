import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:pulse_gym/componnents/active-workouts.dart';
import 'package:pulse_gym/componnents/workouts-list.dart';
import 'package:pulse_gym/services/auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Kay, kay}) : super(key: kay);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int sectionIndex = 0;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var navigationBar = CurvedNavigationBar(
      items: const <Widget>[Icon(Icons.fitness_center), Icon(Icons.search)],
      index: 0,
      height: 50,
      color: Colors.white.withOpacity(0.5),
      backgroundColor: Colors.white30,
      buttonBackgroundColor: Colors.white.withOpacity(0.5),
      animationCurve: Curves.easeInOut,
      animationDuration: Duration(microseconds: 500),
      onTap: (int index) {
        setState(() => sectionIndex = index);
      },
    );
    return Container(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: AppBar(
            title: Text('Pulse Gym//' +
                (sectionIndex == 0 ? 'Active Workouts' : 'Find Workouts')),
            leading: Icon(Icons.fitness_center),
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () {
                    AuthService().logOut();
                  },
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                  ),
                  label: SizedBox.shrink())
            ],
          ),
          body: sectionIndex == 0 ? ActiveWorkouts() : WorkoutsLists(),
          bottomNavigationBar: navigationBar,
        ),
      ),
    );
  }
}
