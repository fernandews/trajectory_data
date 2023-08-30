import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:async';
import 'package:trajectory_data/src/internal_persistence/internal_persistence.dart';
import 'package:trajectory_data/src/send_data/send_data.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';

class Geolocation {
  final int id;
  final int user;
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
}

void startServices(int user) {

  print("Antes de tudo");
  startGettingLocation(user);
  //compute<int, void>(startGettingLocation, user);
  print("chamei a função de geolocalização");
  startApiService();
  //compute<void, void>(startApiService, null);
  print("chamei a função de enviar para API");
}

void startApiService() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "send_to_api_task",
    "simplePeriodicTask",
    inputData: <String, dynamic>{},
    frequency: Duration(minutes: 15),
  );
}

void startGettingLocation(int user) {
  const waitingTime = Duration(seconds: 10);
  print("startGettingLocation callback executed");
  print(waitingTime);
  Timer.periodic(waitingTime, (timer) {
    print("Timer callback executed");
    getGeolocation(user);});
}

  // request de current position, insert in a list e check the time to send the list
Future<void> getGeolocation(int user) async {
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
Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  permission = await Geolocator.checkPermission();

  if(permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      return Future.error('Location Permissions are denied');
    }
  }
  return Geolocator.getCurrentPosition();
}









