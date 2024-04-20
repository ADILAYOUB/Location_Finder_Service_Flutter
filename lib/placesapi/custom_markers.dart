import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkers extends StatefulWidget {
  const CustomMarkers({super.key});

  @override
  State<CustomMarkers> createState() => _CustomMarkersState();
}

class _CustomMarkersState extends State<CustomMarkers> {
  final Completer<GoogleMapController> controller = Completer();
  static CameraPosition _initialPosition = CameraPosition(
    target: LatLng(7.8774222, 80.7003428),
    zoom: 14.4746,
  );
  final List<Marker> mymarker = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
