import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Map data;
void main() async {
  data = await getJSON();
  //print(data['features'][0]['properties']['mag']);
  runApp(MyApp());
}

class MyApp extends MaterialApp {
  @override
  String get title => 'Quake History';
  @override
  bool get debugShowCheckedModeBanner => false;
  @override
  Widget get home => QuakeHistory();
}

Future<Map> getJSON() async {
  // the response here starts with a { not a [
  // this means that it's a map not a list
  String apiURL =
      'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson';
  http.Response response = await http.get(apiURL);
  return json.decode(response.body);
}

Color magColor(num mag) {
  if (mag < 1.5) {
    return Colors.green;
  } else if (mag > 4.5) {
    return Colors.red;
  } else {
    return Colors.orange;
  }
}

class QuakeHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quake History'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: ListView.builder(
          itemCount: data['features'].length,
          padding: EdgeInsets.all(10.5),
          itemBuilder: (BuildContext context, int position) {
            return Column(
              children: <Widget>[
                Divider(
                  height: 2.2,
                ),
                ListTile(
                  title: Text(
                    '${data['features'][position]['properties']['title']}',
                    style: TextStyle(fontSize: 15.9),
                  ),
                  subtitle: Text(
                    data['features'][position]['properties']['type'],
                    style: TextStyle(
                      fontSize: 11.9,
                    ),
                  ),
                  leading: CircleAvatar(
                    child: Text(
                      '${data['features'][position]['properties']['mag']}',
                    ),
                    backgroundColor: magColor(
                        data['features'][position]['properties']['mag']),
                    foregroundColor: Colors.white,
                  ),
                  onTap: () {
//                    DateFormat dF = DateFormat('MMM dd yyyy H:mm:ss');
                    DateFormat dF = DateFormat('EEE dd MMM yyyy HH:mm:ss');
                    DateTime quakeTime = DateTime.fromMillisecondsSinceEpoch(
                        (data['features'][position]['properties']['time']));
                    String quakeTS = dF.format(quakeTime.toUtc());
                    showOnTapDB(
                        context,
                        data['features'][position]['properties']['place'],
                        quakeTS);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void showOnTapDB(BuildContext context, String message, String time) {
  var alert = AlertDialog(
    title: Text('Time details'),
    content: Text('Happened on $time UTC'),
    actions: <Widget>[
      Center(
        child: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ),
    ],
  );
  //showDialog(context: context,child: alert);
  showDialog(context: context, builder: (context) => alert);
}
