import 'dart:async';
import 'package:trajectory_data/trajectory_data.dart';
import 'package:trajectory_data/src/user/user.dart';
import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

class Geofencing {
  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  String geofenceStatus = '';


  void startGeofencing(String latitude, String longitude) {
    EasyGeofencing.startGeofenceService(
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: "1000.0",
        eventPeriodInSeconds: 60);

    geofenceStatusStream ??= EasyGeofencing.getGeofenceStream()!
        .listen((GeofenceStatus status) {
        if (geofenceStatus != status.toString()) {
          geofenceStatus = status.toString();
          if (status.toString() == GeofenceStatus.enter.toString()) {
            startServices();
          }
        }
    });
  }

  void stopGeofencing () {
    EasyGeofencing.stopGeofenceService();
    geofenceStatusStream!.cancel();
  }

}

void startTrajectoryData(
  {String user = '',
  String latitude = '0',
  String longitude = '0',
  List<String>? mensagens}) {
  startUserService(user);
  Geofencing geofencing = Geofencing();
  geofencing.startGeofencing(latitude, longitude);
}