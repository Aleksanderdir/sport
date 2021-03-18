import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pulse_gym/components/common/workout-level.dart';
import 'package:pulse_gym/core/constants.dart';
import 'package:pulse_gym/domain/user.dart';
import 'package:pulse_gym/domain/workout.dart';
import 'package:pulse_gym/screens/add-workout.dart';
import 'package:pulse_gym/services/database.dart';
import 'package:provider/provider.dart';

class WorkoutDetails extends StatefulWidget {
  final String id;
  const WorkoutDetails({Key key, @required this.id}) : super(key: key);

  @override
  _WorkoutDetailsState createState() => _WorkoutDetailsState();
}

class _WorkoutDetailsState extends State<WorkoutDetails> {
  WorkoutSchedule workout;
  User user;
  var db = DatabaseService();
  @override
  void initState() {
    _loadWorkout();
    super.initState();
  }

  void _loadWorkout() {
    db.getWorkout(widget.id).then((w){
      setState(() {
        workout = w;
      });
    });
  }

  bool _isAuthor() =>
      user != null && workout != null && user.id == workout.author;

  Widget _buildHeader(BuildContext context) => Stack(children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/gym.jpg'),
                fit: BoxFit.cover
              )
            ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          padding: EdgeInsets.all(20.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 68, 85, .9)),
          child: Center(
            child: _buildTopContentText(),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 30, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              _isAuthor()
                  ? IconButton(
                      icon: Icon(Icons.edit),
                      color: Colors.white,
                      onPressed: () async {
                        var updatedWorkout =
                            await Navigator.push<WorkoutSchedule>(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => AddWorkout(
                                          workoutSchedule: workout,
                                        )));
                        if (updatedWorkout != null) _loadWorkout();
                      },
                    )
                  : SizedBox.shrink()
            ],
          ),
        ),
      ]);

  Widget _buildTopContentText() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 60.0),
          Text(
            workout.title,
            style: TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          SizedBox(height: 20.0),
          Text(
            workout.description,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            maxLines: 5,
          ),
          SizedBox(height: 20.0),
          Expanded(
              child: Column(
            children: [
              WorkoutLevel(level: workout.level),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ))
        ],
      );

  Widget _buildWorkoutDay(WorkoutWeekDay day) => Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        color: bgColorActive2,
        child: Column(
          children: (day.drillBlocks == null || day.drillBlocks.length == 0)
              ? <Widget>[
                  Text(
                      'Relax, even machines need rest... well at least sometimes! Ok, ok, you can do some active recovery today',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                ]
              : day.drillBlocks
                  .map((block) => _buildDrillBlock(
                      block, day.getNotRestDrillBlockIndex(block)))
                  .toList(),
        ),
      );

  Widget _bildDrill(WorkoutDrill drill, int index, bool single) => ListTile(
        title: Text(
          '${single ? '' : '${index + 1}) '}${drill.title}',
          style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.headline6.fontSize),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${drill.sets}x${drill.reps}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Theme.of(context).textTheme.headline6.fontSize,
                    fontStyle: FontStyle.italic)),
            (drill.weight != null && drill.weight.isNotEmpty)
                ? Text('with weight: ${drill.weight}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.headline6.fontSize,
                        fontStyle: FontStyle.italic))
                : SizedBox.shrink()
          ],
        ),
      );

  Widget _buildDrillBlock(WorkoutDrillsBlock block, int index) {
    Widget widget = SizedBox.shrink();

    var workoutDrills = block.drills
        .map((drill) => _bildDrill(
            drill, block.drills.indexOf(drill), block.drills.length == 1))
        .toList();

    switch (block.type) {
      case WorkoutDrillType.SINGLE:
        widget = Container(
            color: bgColorActive3,
            margin: EdgeInsets.symmetric(vertical: 5),
            child: Column(
              children: <Widget>[
                Text(
                  'Single',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.MULTISET:
        widget = Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'MultiSet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.AMRAP:
        var amrapBlock = block as WorkoutAmrapDrillBlock;
        widget = Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                Text('AMRAP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('${amrapBlock.minutes} min',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.ForTime:
        var forTimeBlock = block as WorkoutForTimeDrillBlock;
        widget = Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                Text('For Time',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                forTimeBlock.rounds > 1
                    ? Text('${forTimeBlock.rounds} rounds',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                    : SizedBox.shrink(),
                forTimeBlock.restBetweenRoundsMin > 0
                    ? Text(
                        '${forTimeBlock.restBetweenRoundsMin} min rest between rounds',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))
                    : Text('No Rest',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                Text('${forTimeBlock.timeCapMin} min time cap',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.EMOM:
        var emomBlock = block as WorkoutEmomDrillBlock;
        widget = Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: bgColorActive3,
            child: Column(
              children: <Widget>[
                Text('EMOM',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text('every ${emomBlock.intervalMin} min',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text('for total ${emomBlock.timeCapMin} min',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                ...workoutDrills
              ],
            ));
        break;
      case WorkoutDrillType.REST:
        widget = Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            color: bgColorRest,
            child: ListTile(
              title: Text(
                  'Rest ${(block as WorkoutRestDrillBlock).timeMin} min',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ));
        break;
    }

    return Stack(
      children: <Widget>[
        widget,
        index >= 0
            ? Positioned(
                top: 0,
                left: 0,
                child: SizedBox(
                  width: 30,
                  height: 20,
                  child: Container(
                    color: Colors.blue,
                    child: Center(
                        child: Text('${index + 1}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold))),
                  ),
                ))
            : SizedBox.shrink()
      ],
    );
  }

  Widget _buildWorkoutWeek(WorkoutWeek week) => Column(
        children: week.days
            .map((day) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: bgColorActive2),
                  child: ExpansionTileCard(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    baseColor: bgColorInactive,
                    expandedColor: bgColorActive2,
                    leading: Container(
                      padding: EdgeInsets.only(right: 12),
                      child: day.isSet
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
                              right:
                                  BorderSide(width: 1, color: Colors.white24))),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            'Day ${week.days.indexOf(day) + 1} - ' +
                                (day.isSet
                                    ? '${day.notRestDrillBlocksCount} drills'
                                    : 'Rest Day'),
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.headline6.color,
                                fontWeight: FontWeight.bold)),
                        day.notes != null && day.notes.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.info),
                                color: Colors.white,
                                onPressed: () {
                                  _showNotes(
                                      'Day ${week.days.indexOf(day) + 1} notes',
                                      day.notes);
                                },
                              )
                            : SizedBox.shrink()
                      ],
                    ),
                    children: <Widget>[_buildWorkoutDay(day)],
                    // trailing: Icon(Icons.keyboard_arrow_right,
                    //     color: Theme.of(context).textTheme.title.color),
                  ),
                ))
            .toList(),
      );

  Future<void> _showNotes(String title, String notes) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(notes),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildWorkoutWeeks() => Container(
      child: Column(
          children: workout.weeks
              .map((week) => Container(
                    padding: EdgeInsets.only(top: 5),
                    //decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    child: ExpansionTileCard(
                      baseColor: bgColorInactive,
                      expandedColor: bgColorActive,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
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
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Week ${workout.weeks.indexOf(week) + 1} - ${week.daysWithDrills} Training Days',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      .color,
                                  fontWeight: FontWeight.bold)),
                          week.notes != null && week.notes.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.info),
                                  color: Colors.white,
                                  onPressed: () {
                                    _showNotes(
                                        'Week ${workout.weeks.indexOf(week) + 1} notes',
                                        week.notes);
                                  },
                                )
                              : SizedBox.shrink()
                        ],
                      ),
                      children: <Widget>[_buildWorkoutWeek(week)],
                    ),
                  ))
              .toList()));

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);

    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: workout == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    _buildHeader(context),
                    _buildWorkoutWeeks()
                  ],
                ),
              ));
  }
}
