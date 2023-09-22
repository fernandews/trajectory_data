import 'dart:async';
import 'package:trajectory_data/trajectory_data.dart';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

class Geofencing {
  StreamSubscription<GeofenceStatus>? geofenceStatusStream;
  String geofenceStatus = '';


  void startGeofencing(String latitude, String longitude) {
    EasyGeofencing.startGeofenceService(
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: "250.0",
        eventPeriodInSeconds: 30);

    geofenceStatusStream ??= EasyGeofencing.getGeofenceStream()!
        .listen((GeofenceStatus status) {
        if (geofenceStatus != status.toString()) {
          geofenceStatus = status.toString();
          if (status.toString() == GeofenceStatus.enter.toString()) {
            startServices(2);
          }
        }
    });
  }

  void stopGeofencing () {
    EasyGeofencing.stopGeofenceService();
    geofenceStatusStream!.cancel();
  }


}