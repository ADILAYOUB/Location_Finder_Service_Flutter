import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class TransformLatLng extends StatefulWidget {
  const TransformLatLng({super.key});

  @override
  State<TransformLatLng> createState() => _TransformLatLngState();
}

class _TransformLatLngState extends State<TransformLatLng> {
  String placeM = '';
  String address = '';
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 100),
            Text(
              address,
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
            Text(
              placeM,
              style: TextStyle(color: Colors.black, fontSize: 35),
            ),
            GestureDetector(
              onTap: () async {
                List<Location> location =
                    await locationFromAddress('Sri Lanka , Dambulla');

                List<Placemark> placemark =
                    await placemarkFromCoordinates(7.8774222, 80.7003428);
                setState(() {
                  placeM = '${placemark.reversed.last.country}'
                      '${placemark.reversed.last.locality}';

                  address =
                      '${location.last.longitude}' '${location.last.latitude}';
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Tap me to convert",
                  style: TextStyle(fontSize: 36),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
