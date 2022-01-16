import 'package:dynamicrouteplanner/FirebaseAuthAPI/ProxyAuthAPI.dart';
import 'package:dynamicrouteplanner/Screens/Passenger/PassengerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dynamicrouteplanner/StaticConstants/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChangeLocation extends StatefulWidget {
  const ChangeLocation({Key key}) : super(key: key);

  @override
  _ChangeLocationState createState() => _ChangeLocationState();
}

class _ChangeLocationState extends State<ChangeLocation> {

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(40.8809433, 29.2577417),
    zoom: 7.4746,
  );

  Set<Marker> _markers = {};
  BitmapDescriptor studentPin;
  Marker _newPos;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DRPAuthAPI().setStudent();
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _kGooglePlex = CameraPosition(
        target: LatLng(student["lat"], student["lng"]),
        zoom: 11.4746,
      );
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
    });
  }

  @override
  Widget build(BuildContext context) {

      return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueAccent[200],
            title: Text("Dynamic Route Planner - Student"),
          ),
          body: Column(
            children:
            [
              Expanded(
                child: Container(
                        child: GoogleMap(
                            mapType: MapType.normal,
                            onMapCreated: _onMapCreated,
                            markers: _markers,
                            onLongPress: _addMarker,
                            initialCameraPosition: _kGooglePlex
                            ),
                      ),
                ),
              Container(
                color: Colors.blueAccent[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () async {
                          if (_newPos != null) {
                            if (_newPos.position != null)
                              student["lat"] = _newPos.position.latitude;
                            if (_newPos.position != null)
                              student["lng"] = _newPos.position.longitude;
                          }
                          student["locationUpdate"] = true;
                          student["incoming"] = true;
                          await DRPAuthAPI().addPassenger(student);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Passenger()), ModalRoute.withName("/Home"));
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                        child: Text("Update New Location")),
                    TextButton(
                        onPressed: () async {
                          student["incoming"] = false;
                          await DRPAuthAPI().addPassenger(student);
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Passenger()), ModalRoute.withName("/Home"));
                        },
                        style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
                        child: Text("Don't Come")),
                  ],
                ),
              )
            ]
          ),
        ),
        onWillPop: () {
          Navigator.pop(context);
        });
  }
  void _addMarker(LatLng pos) {
    setState( () {
      if (_markers.length == 2) {
        _markers.remove(_newPos);
      }
      _newPos =  Marker(
        markerId: MarkerId('id-2'),
        position: pos,
        infoWindow: InfoWindow(
          title: "Selected Location",
          snippet: "Your new location",
        ),
      );
    });
    _markers.add(_newPos);
    print(_newPos.position);
  }
}
