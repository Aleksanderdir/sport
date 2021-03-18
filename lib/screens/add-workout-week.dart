import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pulse_gym/components/common/save-button.dart';
import 'package:pulse_gym/core/constants.dart';
import 'package:pulse_gym/domain/workout.dart';
import 'package:pulse_gym/screens/add-workout-day.dart';

class AddWorkoutWeek extends StatefulWidget {
  final WorkoutWeek week;
  AddWorkoutWeek({Key key, this.week}) : super(key: key);

  @override
  _AddWorkoutWeekState createState() => _AddWorkoutWeekState();
}

class _AddWorkoutWeekState extends State<AddWorkoutWeek> {
  final _fbKey = GlobalKey<FormBuilderState>();

  WorkoutWeek week = WorkoutWeek();

  @override
  void initState() {
    if (widget.week != null && widget.week.days.length == 7)
      week = widget.week.copy();
    else
      week.days = [
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: []),
        WorkoutWeekDay(drillBlocks: [])
      ];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pulse_gym // Create Week Plan'),
        actions: <Widget>[
          SaveButton(
            onPressed: () {
              Navigator.of(context).pop(week);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: bgColorWhite),
          child: Column(
            children: <Widget>[
              ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: week.days.length,
                  itemBuilder: (context, i) {
                    return Card(
                      elevation: 2.0,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: InkWell(
                        onTap: () async {
                          var day = week.days[i];
                          var newDay = await Navigator.push<WorkoutWeekDay>(
                              context,
                              MaterialPageRoute(
                                  builder: (ctx) => AddWorkoutDay(day: day)));
                          if (newDay != null)
                            setState(() {
                              week.days[i] = newDay;
                            });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 65, 85, 0.9)),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            leading: Container(
                              padding: EdgeInsets.only(right: 12),
                              child: week.days[i].isSet
                                  ? Icon(
                                      Icons.check,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.hourglass_empty,
                                      color: Colors.blue,
                                    ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right: BorderSide(
                                          width: 1, color: Colors.white24))),
                            ),
                            title: Text(
                                'Day ${i + 1} - ' +
                                    (week.days[i].isSet
                                        ? '${week.days[i].notRestDrillBlocksCount} drills'
                                        : 'Rest Day'),
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
                    );
                  }),
              FormBuilder(
                key: _fbKey,
                //   autovalidate: false,
                initialValue: {},
                //  readOnly: false,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FormBuilderTextField(
                    name: "notes",
                    decoration: InputDecoration(
                      labelText: "Notes",
                    ),
                    initialValue: week.notes,
                    onChanged: (dynamic val) {
                      setState(() {
                        week.notes = val;
                      });
                    },
                    //  validator: [
                    //    FormBuilderValidators.maxLength(500),
                    //   ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
