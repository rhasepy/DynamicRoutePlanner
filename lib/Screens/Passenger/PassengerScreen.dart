import 'dart:async';
import 'package:dynamicrouteplanner/Screens/Passenger/ChangeLocation.dart';
import 'package:dynamicrouteplanner/StaticConstants/constants.dart';
import 'package:dynamicrouteplanner/components/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../main.dart';

class Passenger extends StatelessWidget {
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

  Widget Passenger_DrawerList()
  {
    return Container(
      padding: EdgeInsets.only(top: 15,),
      child: Column(
        children: [
          _ExitDrawer()
        ],
      ),
    );
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(student["lat"], student["lng"]),
    zoom: 11.4746,
  );

  Set<Marker> _markers = {};
  BitmapDescriptor driverPin;

  @override
  void initState() {
    super.initState();
    setDriverMarker();
  }

  void setDriverMarker() async {
    driverPin = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/images/busDriver.png');
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(student["lat"], student["lng"]),
            infoWindow: InfoWindow(
              title: "You",
              snippet: "Your location",
            ),
        )
      );
      _markers.add(
          Marker(markerId: MarkerId('id-2'), position: LatLng(driver["lat"], driver["lng"]),
              icon: driverPin,
              infoWindow: InfoWindow(
                  title: "Bus Driver",
                  snippet: "Your Bus Driver Location"
              ),
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        title: Text("Dynamic Route Planner - Student"),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        markers: _markers,
        initialCameraPosition: _kGooglePlex
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                Passenger_DrawerList()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ChangeLocation()), ModalRoute.withName("/Home"));
        },
        label: Text('Change Location'),
        icon: Icon(Icons.directions_walk),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}