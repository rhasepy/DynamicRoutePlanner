import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/Passenger/ChangeLocation.dart';
import 'package:dynamicrouteplanner/StaticConstants/constants.dart';
import 'package:dynamicrouteplanner/components/drawer_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';
import 'package:location/location.dart' as loc;

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

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.8809433, 29.2577417),
    zoom: 7.4746,
  );

  Set<Marker> _markers = {};
  BitmapDescriptor driverPin;
  BitmapDescriptor studentPin;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestPermission();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        DRPAuthAPI().setStudent();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        DRPAuthAPI().setDriver();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _kGooglePlex = CameraPosition(
        target: LatLng(student["lat"], student["lng"]),
        zoom: 11.4746,
      );
    });


    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/bus.png')
        .then((value) {
      driverPin = value;
    });
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(), 'assets/images/student.png')
        .then((value) {
      studentPin = value;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(
        Marker(
            markerId: MarkerId('id-1'),
            position: LatLng(student["lat"], student["lng"]),
            icon: studentPin,
            infoWindow: InfoWindow(
              title: "You",
              snippet: "Your location",
            ),
        )
      );
      if (driver != null) {
        _markers.add(
            Marker(
              markerId: MarkerId('id-2'),
              position: LatLng(driver["lat"], driver["lng"]),
              icon: driverPin,
              infoWindow: InfoWindow(
                  title: "Bus Driver",
                  snippet: "Your Bus Driver Location"
              ),
            )
        );
      }
    });
  }

  void updateDriverMarker() {

      if (_markers.length > 1) {
        _markers.remove(_markers.elementAt(1));
        _markers.add(Marker(
          markerId: MarkerId('id-2'),
          position: LatLng(driver["lat"], driver["lng"]),
          icon: driverPin,
          infoWindow: InfoWindow(
              title: "Bus Driver",
              snippet: "Your Bus Driver Location"
          ),
        ));
      }
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        title: Text("Dynamic Route Planner - Student"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Drivers').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            // Update just driver location that is user's driver
            bool isUpdate = false;
            try {
              for (int i = 0; i < snapshot.data.docs.length; ++i) {
                if (driver != null) {
                  if (snapshot.data.docs[i]['email'] == driver['email']) {
                    isUpdate = true;
                    driver['lat'] = snapshot.data.docs[i]['lat'];
                    driver['lng'] = snapshot.data.docs[i]['lng'];
                  }
                }
              }
            } catch (e) {}
            if (isUpdate)
              updateDriverMarker();

            return GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                markers: _markers,
                initialCameraPosition: _kGooglePlex
            );
          }
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

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}