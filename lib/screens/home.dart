import 'package:flutter/material.dart';
import 'package:pulse_gym/domain/workout.dart';
import 'package:pulse_gym/services/auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({Kay, kay}) : super(key: kay);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text('Pulse Gym'),
        leading: Icon(Icons.fitness_center),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                AuthService().logOut();
              },
              icon: Icon(Icons.supervised_user_circle, color: Colors.white),
              label: SizedBox.shrink())
        ],
      ),
      body: WorkoutsLists(),
    ));
  }
}

class WorkoutsLists extends StatelessWidget {
  final workouts = <Workout>[
    Workout(
        title: 'Test1',
        autor: "Alex's1",
        description: 'Test Workout',
        level: 'Begginer'),
    Workout(
        title: 'Test2',
        autor: "Alex's2",
        description: 'Test Workout',
        level: 'Intermediate'),
    Workout(
        title: 'Test3',
        autor: "Alex's3",
        description: 'Test Workout',
        level: 'Advanced'),
    Workout(
        title: 'Test4',
        autor: "Alex's4",
        description: 'Test Workout',
        level: 'Begginer'),
    Workout(
        title: 'Test5',
        autor: "Alex's5",
        description: 'Test Workout',
        level: 'Intermediate'),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Container(
        child: ListView.builder(
            itemCount: workouts.length,
            itemBuilder: (context, i) {
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Container(
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(50, 65, 85, 0.5)),
                  child: ListTile(
                    leading: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        Icons.fitness_center,
                        color: Theme.of(context).textTheme.title.color,
                      ),
                      decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(
                        width: 1,
                        color: Theme.of(context).textTheme.title.color,
                      ))),
                    ),
                    title: Text(
                      workouts[i].title,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.title.color,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(context).textTheme.title.color,
                    ),
                    subtitle: subtitle(context, workouts[i]),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

Widget subtitle(BuildContext context, Workout workout) {
  var color = Colors.grey;
  double indicatorLevel = 0;

  switch (workout.level) {
    case 'Begginer':
      color = Colors.green;
      indicatorLevel = 0.33;
      break;

    case 'Intermediate':
      color = Colors.yellow;
      indicatorLevel = 0.66;
      break;

    case 'Advanced':
      color = Colors.red;
      indicatorLevel = 1.0;
      break;
  }
  return Row(
    children: <Widget>[
      Expanded(
        flex: 1,
        child: LinearProgressIndicator(
          backgroundColor: Theme.of(context).textTheme.title.color,
          value: indicatorLevel,
          valueColor: AlwaysStoppedAnimation(color),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          workout.level,
          style: TextStyle(color: Theme.of(context).textTheme.title.color),
        ),
        flex: 3,
      )
    ],
  );
}
