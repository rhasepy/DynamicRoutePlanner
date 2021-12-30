import 'package:dynamicrouteplanner/Screens/Driver/AddPassenger.dart';
import 'package:dynamicrouteplanner/components/drawer_header.dart';
import 'package:dynamicrouteplanner/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Driver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample>
{
  Completer<GoogleMapController> _controller = Completer();

  Widget _AddPassengerDrawer()
  {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddPassenger()), ModalRoute.withName("/Home"));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/Main.png'),
                  ),
                ),
              ),
              Text("Add Passengers", style: TextStyle(color: Colors.black, fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ExitDrawer()
  {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), ModalRoute.withName("/Home"));
            },
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: 20),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/icons/Main.png'),
                  ),
                ),
              ),
              Text("Exit", style: TextStyle(color: Colors.black, fontSize: 20),),
            ],
          ),
        ),
      ),
    );
  }

  Widget Driver_DrawerList()
  {
    return Container(
      padding: EdgeInsets.only(top: 15,),
      child: Column(
        children: [
          _AddPassengerDrawer(),
          _ExitDrawer()
        ],
      ),
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        title: Text("Dynamic Route Planner - Driver"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                Driver_DrawerList()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: Text('Find Shortest Path'),
        icon: Icon(Icons.directions_car),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}