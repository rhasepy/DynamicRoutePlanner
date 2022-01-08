import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamicrouteplanner/CoreAlgorithm/DynamicACO.dart';
import 'package:dynamicrouteplanner/StaticConstants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadToCalculate extends StatefulWidget
{
  const LoadToCalculate({Key key}) : super(key: key);

  @override
  _LoadToCalculateState createState() => _LoadToCalculateState();
}

class _LoadToCalculateState extends State<LoadToCalculate> {

  void _clear_memory() {}

  // return decameter
  double calculateDistance(lat1, lon1, lat2, lon2) {

    if (lat1 == lat2 && lon1 == lon2) {
      return -1;
    }

    if (driver != null) {
      if (lat1 == driver["lat"] && lon1 == driver["lng"]) {
        if (lat2 == driver["sLat"] && lon2 == driver["sLng"]) {
          return 0;
        }
      } else if (lat2 == driver["lat"] && lon2 == driver["lng"]) {
        if (lat1 == driver["sLat"] && lon1 == driver["sLng"]) {
          return 0;
        }
      }
    }

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p))/2;
    return 100 * 12742 * asin(sqrt(a));
  }

  void _run_algorithm() async
  {
    List<Map<String, dynamic>> comingStudents = [];

    if (driver != null) {
      for (String item in driver["incomingList"]) {
        await FirebaseFirestore.instance.collection('Passengers').doc(item).get().then((value) => {
          comingStudents.add(value.data())
        });
      }
      Map<String, dynamic> school =
      {
          "lat"   : driver["sLat"],
          "lng"   : driver["sLng"],
          "name"  : "School"
      };
      comingStudents.add(school);
      comingStudents.add(driver);
      List<List<double>> graph = List.generate(comingStudents.length, (index) => List.generate(comingStudents.length, (index) => null));
      for (int i = 0; i < comingStudents.length; ++i) {
        for (int j = 0; j < comingStudents.length; ++j) {
          double cost = calculateDistance(comingStudents[i]["lat"], comingStudents[i]["lng"], comingStudents[j]["lat"], comingStudents[j]["lng"]);
          graph[i][j] = cost;
        }
      }

      List<String> places = [];
      for (int i = 0; i < comingStudents.length; ++i) {
        places.add(comingStudents[i]["name"].toString());
      }
      new DynamicACO(5, graph, 50, places, null).run();
    }
  }

  @override
  Widget build(BuildContext context) {

    _run_algorithm();

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent[200],
            title: Text("Dynamic Route Planner - Driver"),
          ),
          body: Text("Hesaplaniyor"),
        ),
        onWillPop: () {
          _clear_memory();
          Navigator.pop(context);
        });
  }
}
