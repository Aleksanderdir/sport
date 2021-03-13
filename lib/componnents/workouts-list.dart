import 'package:flutter/material.dart';
import 'package:pulse_gym/domain/workout.dart';

class WorkoutsLists extends StatefulWidget {
  @override
  _WorkoutsListsState createState() => _WorkoutsListsState();
}

class _WorkoutsListsState extends State<WorkoutsLists> {
  @override
  void initState() {
    clearFilter();
    super.initState();
  }

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
  var filterOnlyMyWorkouts = false;
  var filterTitle = '';
  var filterTitleController = TextEditingController();
  var filterLevel = 'Any Level';
  var filterText = '';
  var filterHeght = 0.0;

  List<Workout> filter() {
    setState(() {
      filterText = filterOnlyMyWorkouts ? 'My Worcouts' : 'All worcouts';
      filterText += '/' + filterLevel;
      print(filterTitle);
      if (filterTitle.isNotEmpty) filterText += '/' + filterTitle;
      filterHeght = 0;
    });

    var list = workouts;
    return list;
  }

  List<Workout> clearFilter() {
    setState(() {
      filterText = 'All workouts/Any Level';
      filterOnlyMyWorkouts = false;
      filterTitle = '';
      filterLevel = 'Any Level';
      filterTitleController.clear();
      filterHeght = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var workoutsList = Expanded(
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
    );
    var filterInfo = Container(
      margin: EdgeInsets.only(top: 3, left: 7, right: 7, bottom: 5),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5)),
      height: 40,
      child: RaisedButton(
        child: Row(
          children: <Widget>[
            Icon(Icons.filter_list),
            Text(
              filterText,
              style: TextStyle(),
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
        onPressed: () {
          setState(() {
            filterHeght = (filterHeght == 0.0 ? 280.0 : 0.0);
          });
        },
      ),
    );

    var levelMenuItems = <String>[
      'Any Level',
      'Beginner',
      'Intermediate',
      'Advanced'
    ].map((String value) {
      return new DropdownMenuItem<String>(
        value: value,
        child: new Text(value),
      );
    }).toList();
    var filterForm = AnimatedContainer(
      margin: EdgeInsets.symmetric(vertical: 0.0, horizontal: 7),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SwitchListTile(
                  title: const Text('Only My Workouts'),
                  value: filterOnlyMyWorkouts,
                  onChanged: (bool val) =>
                      setState(() => filterOnlyMyWorkouts = val)),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Level'),
                items: levelMenuItems,
                value: filterLevel,
                onChanged: (String val) => setState(() => filterLevel = val),
              ),
              TextFormField(
                controller: filterTitleController,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (String val) => setState(() => filterTitle = val),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        filter();
                      },
                      child:
                          Text('Apply', style: TextStyle(color: Colors.white)),
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {
                        clearFilter();
                      },
                      child: Text(
                        'Clear',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
      height: filterHeght,
    );

    return Column(
      children: <Widget>[
        filterInfo,
        filterForm,
        workoutsList,
      ],
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
