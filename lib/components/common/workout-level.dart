import 'package:flutter/material.dart';

class WorkoutLevel extends StatelessWidget {
  final String level;
  const WorkoutLevel({Key key, @required this.level}) : super(key: key);

Widget getLevel(BuildContext context, String level) {
  var color = Colors.grey;
  double indicatorLevel = 0;

  switch (level) {
    case 'Beginner':
      color = Colors.green;
      indicatorLevel = 0.33;
      break;
    case 'Intermediate':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;
    case 'Advanced':
      color = Colors.red;
      indicatorLevel = 1;
      break;
  }

  return Row(
    children: <Widget>[
      Expanded(
          flex: 1,
          child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).textTheme.headline6.color,
              value: indicatorLevel,
              valueColor: AlwaysStoppedAnimation(color))),
      SizedBox(width: 10),
      Expanded(
          flex: 3,
          child: Text(level,
              style: TextStyle(color: Theme.of(context).textTheme.headline6.color)))
    ],
  );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getLevel(context, level),
    );
  }
}