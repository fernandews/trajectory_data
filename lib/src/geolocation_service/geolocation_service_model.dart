import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/user/user.dart';
import 'package:trajectory_data/src/internal_persistence/internal_persistence.dart';


class GeolocationServiceModel {
  final int id;
  final String user;
  final String datetime;
  static List<List<double>> trajectory = [];

  // request the current position, insert in a list e check the time to send the list

//check permission e capture the current position
  static Future<List<double>> determinePosition() async {
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
    trajectory.add(currentLocation);
  }
}