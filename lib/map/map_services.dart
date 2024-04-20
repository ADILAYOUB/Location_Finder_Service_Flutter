import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapServices {
  String convertedAddress = "";
  String coordinatesFromAddress = "";

  //conversion of coordinates to address
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];
    convertedAddress =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
    return convertedAddress;
  }

  //conversion of address to coordinates
  Future<List<Location>> getCoordinatesFromAddress(String address) async {
    List<Location> locations = await locationFromAddress(address);
    coordinatesFromAddress = locations.toString();
    return locations;
  }

  //get user access to allow location
  Future<Position> getUserLocationAccess() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print('error $error');
    });

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  

 

  /*CameraPosition cameraPosition = CameraPosition(
                            target: LatLng(locations.last.latitude,
                                locations.last.longitude),
                            zoom: 14);
                        GoogleMapController controller =
                            await this.controller.future;

                        controller.animateCamera(
                            CameraUpdate.newCameraPosition(cameraPosition));
                            */
  


}
