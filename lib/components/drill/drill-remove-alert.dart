import 'package:flutter/material.dart';

Widget drillRemoveAlert(BuildContext context) {
  return AlertDialog(
    title: Text('Remove Drill'),
    content: Text(
      'Do you want to remove this Drill?',
      style: TextStyle(fontSize: 20.0),
    ),
    actions: <Widget>[
      FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Yes')),
      FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('No')),
    ],
  );
}
