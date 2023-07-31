import 'package:geolocator/geolocator.dart';
import 'dart:developer' as dev;
import 'dart:async';

class Geolocation {
  static List<List<double>> trajectory = [];
  static void startGettingLocation() {
    const tempoDeEspera = Duration(seconds: 20);
    Timer.periodic(tempoDeEspera, (timer) {getGeolocation();});
  }

  static void getGeolocation() async {
    Position position = await determinePosition();
    List<double> geolocation = [position.latitude, position.longitude];
    trajectory.add(geolocation);
    if (trajectory.length == 20) {
      dev.log('Fazer request');
    }
    dev.log(trajectory.toString());
  }

  static Future<Position> determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }
}