import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:pulse_gym/components/common/save-button.dart';
import 'package:pulse_gym/components/common/toast.dart';
import 'package:pulse_gym/core/constants.dart';
import 'package:pulse_gym/domain/user.dart';
import 'package:pulse_gym/domain/workout.dart';
import 'package:pulse_gym/screens/add-workout-week.dart';
import 'package:pulse_gym/services/database.dart';

class AddWorkout extends StatefulWidget {
  final WorkoutSchedule workoutSchedule;

  AddWorkout({Key key, this.workoutSchedule}) : super(key: key);

  @override
  _AddWorkoutState createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  final _fbKey = GlobalKey<FormBuilderState>();
  User user;
  WorkoutSchedule workout = WorkoutSchedule(weeks: []);
  bool isNew = true;

  @override
  void initState() {
    if (widget.workoutSchedule != null) {
      isNew = false;
      workout = widget.workoutSchedule.copy();
    }

    if (workout.level == null) workout.level = 'Beginner';

    super.initState();
  }

  void _saveWorkout() async {
    if (_fbKey.currentState.saveAndValidate()) {
      if (workout.weeks == null || workout.weeks.length == 0) {
        buildToast('Please add at least one training week');
        return;
      }

      //print(workout.toMap());
      if (workout.uid == null) {
        workout.author = user.id;
      }

      await DatabaseService().addOrUpdateWorkout(workout);
      Navigator.of(context).pop(workout);
    } else {
      buildToast('Ooops! Something is not right');
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('pulse_gym // ${isNew ? 'Create' : 'Edit'} Workout'),
          actions: <Widget>[SaveButton(onPressed: _saveWorkout)],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.grey,
          foregroundColor: Theme.of(context).primaryColor,
          onPressed: () async {
            var week = await Navigator.push<WorkoutWeek>(
                context, MaterialPageRoute(builder: (ctx) => AddWorkoutWeek()));
            if (week != null)
              setState(() {
                workout.weeks.add(week);
              });
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColorWhite),
            child: FormBuilder(
              // context,
              key: _fbKey,
              // autovalidate: false,
              initialValue: {},
              //  readOnly: false,
              child: Column(
                children: <Widget>[
                  FormBuilderTextField(
                    initialValue: workout.title,
                    name: "title",
                    decoration: InputDecoration(
                      labelText: "Title*",
                    ),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.title = val;
                      });
                    },
                    //validator: [
                    //FormBuilderValidators.required(context,),
                    // FormBuilderValidators.maxLength(context,100),
                    // ],
                  ),
                  FormBuilderDropdown(
                    name: "level",
                    decoration: InputDecoration(
                      labelText: "Level*",
                    ),
                    initialValue: workout.level,
                    allowClear: false,
                    hint: Text('Select Level'),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.level = val;
                      });
                    },
                    // validator: [FormBuilderValidators.required(context,)],
                    items: <String>['Beginner', 'Intermediate', 'Advanced']
                        .map((level) => DropdownMenuItem(
                              value: level,
                              child: Text('$level'),
                            ))
                        .toList(),
                  ),
                  FormBuilderTextField(
                    initialValue: workout.description,
                    name: "description",
                    decoration: InputDecoration(
                      labelText: "Description*",
                    ),
                    onChanged: (dynamic val) {
                      setState(() {
                        workout.description = val;
                      });
                    },
                    // validator: [
                    // FormBuilderValidators.required(context,),
                    // FormBuilderValidators.maxLength(500),
                    //  ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Weeks*',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      // FlatButton(
                      //   child: Icon(Icons.add),
                      //   onPressed: () async {
                      //     var week = await Navigator.push<WorkoutWeek>(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (ctx) => AddWorkoutWeek()));
                      //     if (week != null)
                      //       setState(() {
                      //         workout.weeks.add(week);
                      //       });
                      //   },
                      // )
                    ],
                  ),
                  workout.weeks.length <= 0
                      ? Text(
                          'Please add at least one training week',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : _buildWeeks()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildWeeks() {
    return Container(
        child: Column(
            children: workout.weeks
                .map((week) => Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          var ind = workout.weeks.indexOf(week);
                          var modifiedWeek = await Navigator.push<WorkoutWeek>(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) =>
                                      AddWorkoutWeek(week: week)));
                          if (modifiedWeek != null) {
                            setState(() {
                              workout.weeks[ind] = modifiedWeek;
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 65, 85, 0.9)),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12),
                              child: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Colors.white24))),
                            ),
                            title: Text(
                                'Week ${workout.weeks.indexOf(week) + 1} - ${week.daysWithDrills} Training Days',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .color,
                                    fontWeight: FontWeight.bold)),
                            trailing: Icon(Icons.keyboard_arrow_right,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .color),
                          ),
                        ),
                      ),
                    ))
                .toList()));
  }
}
