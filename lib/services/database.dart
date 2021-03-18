import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pulse_gym/domain/workout.dart';

class DatabaseService{
  final CollectionReference _workoutCollection = Firestore.instance.collection('workouts');
  final CollectionReference _workoutScheduleCollection = Firestore.instance.collection('workoutSchedules');

  Future addOrUpdateWorkout(WorkoutSchedule schedule) async {
    DocumentReference workoutRef = _workoutCollection.document(schedule.uid);

    return workoutRef.setData(schedule.toWorkoutMap()).then((_) async{
      var docId = workoutRef.documentID;
      await _workoutScheduleCollection.document(docId).setData(schedule.toMap());
    });
  }

  Stream<List<Workout>> getWorkouts({String level, String author})
  {
    Query query;
    if(author != null)
      query = _workoutCollection.where('author', isEqualTo: author);
    else
      query = _workoutCollection.where('isOnline', isEqualTo: true);

    if(level != null)
      query = query.where('level', isEqualTo: level);

      //query = query.orderBy('createdOn', descending: true);

    return query.snapshots().map((QuerySnapshot data) =>
        data.documents.map((DocumentSnapshot doc) => Workout.fromJson(doc.data, id: doc.documentID)).toList());
  }

  Future<WorkoutSchedule> getWorkout(String id) async{
    var doc = await _workoutScheduleCollection.document(id).get();
    return WorkoutSchedule.fromJson(doc.documentID, doc.data);
  }
}