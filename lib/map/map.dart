import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:mapapp/map/map_services.dart';
import 'package:uuid/uuid.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  //var for suggestions
  String tokenForSession = '1948';
  List<dynamic> listOfPlaces = [];
  var uuid = Uuid();

  //var for display map
  TextEditingController search = TextEditingController();
  TextEditingController autoCompleteValue = TextEditingController();
  final Completer<GoogleMapController> controller = Completer();
  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(7.8774222, 80.7003428),
    zoom: 14.4746,
  );

  //map service
  MapServices mapServices = MapServices();

  final List<Marker> mymarker = [];
  final List<Marker> anymarker = [];
  final List<Marker> mymarkerList = [
    const Marker(
        markerId: MarkerId('First'),
        position: LatLng(7.8774222, 80.7003428),
        infoWindow: InfoWindow(title: 'First Marker')),
    const Marker(
        markerId: MarkerId('Second'), position: LatLng(7.8774222, 80.713428)),
  ];

  //suggestion
  void makeSuggestion(String input) async {
    String googlePlacesApiKey = 'AIzaSyCCEax977Tl88T7wNZPPWYKyouXuVDRJvA';
    String groundUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$groundUrl?input=$input&key=$googlePlacesApiKey&sessiontoken=$tokenForSession';

    var response = await http.get(Uri.parse(request));

    var resultData = response.body.toString();

    print(resultData);

    if (response.statusCode == 200) {
      setState(() {
        listOfPlaces = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Showing Data Failed Try Again');
    }
  }

  void onModify() {
    if (tokenForSession == null) {
      setState(() {
        tokenForSession = uuid.v4();
      });
    }
    makeSuggestion(search.text);
  }

  @override
  void initState() {
    super.initState();
    mymarker.addAll(mymarkerList);
    anymarker.addAll(mymarkerList);
    search.addListener(() {
      onModify();
    });
  }

  //current location find

  locateMyLocation() {
    mapServices.getUserLocationAccess().then((value) async {
      print('My location');
      print('${value.latitude} ${value.longitude}');

      mymarker.add(
        Marker(
            markerId: MarkerId('Secnod Marker'),
            position: LatLng(value.latitude, value.longitude),
            infoWindow: InfoWindow(title: 'My Current Location')),
      );

      CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude), zoom: 14);

      GoogleMapController controller = await this.controller.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    });
  }

  //any location find
  locateAnyLocation(
      double latitude, double longitude, String locationName) async {
    anymarker.add(
      Marker(
          markerId: MarkerId('123'),
          position: LatLng(latitude, longitude),
          infoWindow: InfoWindow(title: '${locationName}')),
    );

    CameraPosition cameraPosition =
        CameraPosition(target: LatLng(latitude, longitude), zoom: 14);

    GoogleMapController controller = await this.controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      GoogleMap(
        initialCameraPosition: _initialPosition,
        mapType: MapType.normal,
        markers: Set<Marker>.of(mymarkerList),
        onMapCreated: (GoogleMapController _controller) {
          controller.complete(_controller);
        },
      ),
      Container(
        color: Colors.white,
        height: height * 0.2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: search,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Search the place here',
                  fillColor: Colors.transparent,
                ),
              ),
            ),
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: ListView.builder(
                  itemCount: listOfPlaces.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        List<Location> locations = await locationFromAddress(
                            listOfPlaces[index]['description']);

                        await locateAnyLocation(locations.last.latitude,
                            locations.last.longitude, locations.toString());

                        print(locations.last.longitude);
                        print(locations.last.latitude);
                        setState(() {
                          search = TextEditingController(
                              text: listOfPlaces[index]['description']);
                        });
                      },
                      title: Text(listOfPlaces[index]['description']),
                    );
                  }),
            )),
          ],
        ),
      ),
      Positioned(
        top: height * 0.7,
        left: 5,
        child: Container(
          height: height * 0.2,
          width: width * 0.2,
          child: Column(children: [
            FloatingActionButton(
              child: Icon(Icons.location_searching),
              onPressed: () async {
                locateMyLocation();
              },
            ),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {},
            ),
          ]),
        ),
      )
    ])));
  }
}
