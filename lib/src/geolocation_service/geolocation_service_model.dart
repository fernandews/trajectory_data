import 'package:geolocator/geolocator.dart';
import 'dart:async';

class GeolocationServiceModel {
  final List<List<double>> _trajectory = [];

  Future<List<double>> determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    Position position = await Geolocator.getCurrentPosition();
    return [position.latitude, position.longitude];
  }

  void addToTrajectory(List<double> currentLocation) {
    _trajectory.add(currentLocation);
  }

  List<List<double>> getTrajectory () {
    return _trajectory;
  }

  void clearTrajectory () {
    _trajectory.clear();
  }
}