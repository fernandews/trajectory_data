import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:async';
import 'package:trajectory_data/src/internal_persistence/internal_persistence.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:trajectory_data/src/foreground_service/foreground_service.dart';


class Geolocation {
  final int id;
  final int? user;
  final String datetime;
  static List<List<double>> trajectory = [];

  const Geolocation({
    required this.id,
    required this.user,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'datetime': datetime,
      'trajectory': jsonEncode(Geolocation.trajectory),
    };
  }

  Map<String, dynamic> fromMap() {
    return {
      'id': id,
      'user': user,
      'datetime': datetime,
      'trajectory': jsonEncode(Geolocation.trajectory),
    };
  }

  // request de current position, insert in a list e check the time to send the list
  static Future<void> getGeolocation(int? user) async {
    Position position = await determinePosition();
    List<double> geolocation = [position.latitude, position.longitude];
    Geolocation.trajectory.add(geolocation);
    if (Geolocation.trajectory.length == 30) {
      final Geolocation newGeolocation = Geolocation(
        id: 0,
        user: user,
        datetime: DateTime.now().toString(),
      );
      await insertDataInBackground(newGeolocation);
      Geolocation.trajectory.clear();
    }
    print(Geolocation.trajectory.toString());
  }

  //check permission e capture the current position
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    return Geolocator.getCurrentPosition();
  }
}








