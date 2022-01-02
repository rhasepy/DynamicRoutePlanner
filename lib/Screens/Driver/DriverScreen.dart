import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamicrouteplanner/Screens/Driver/AddPassenger.dart';
import 'package:dynamicrouteplanner/components/drawer_header.dart';
import 'package:dynamicrouteplanner/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

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

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData> locationSubscription;

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

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent[200],
        title: Text("Dynamic Route Planner - Driver"),
      ),
      body: Column(
        children: [
          TextButton(onPressed: () {
            _getLocation();
          }, child: Text("Add my location")),
          TextButton(onPressed: () {
            _listenLocation();
          }, child: Text("Enable live location")),
          TextButton(onPressed: () {
            _stopListening();
          }, child: Text("Stop live location")),
          Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Drivers').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(snapshot.data.docs[index]['lat'].toString()),
                            subtitle: Row(
                              children: [
                                Text(snapshot.data.docs[index]['lng'].toString())
                              ],
                            ),
                            trailing: IconButton(icon: Icon(Icons.directions),
                              onPressed: (){
                                print("asd");
                              },),
                          );
                      });
                }
              ),
          ),
        ],
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
        icon: Icon(Icons.directions_bus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('Drivers').doc("ozannyesiller@gmail.com").set({
        'lat': _locationResult.latitude,
        'lng': _locationResult.longitude,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      locationSubscription.cancel();
      setState(() {
        locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('Drivers').doc("ozannyesiller@gmail.com").set({
        'lat': currentlocation.latitude,
        'lng': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    locationSubscription.cancel();
    setState(() {
      locationSubscription = null;
    });
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