import 'dart:async';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

class Geofence {
  StreamSubscription<GeofenceStatus>? _geofenceStatusStream;
  String _geofenceStatus = '';

  String getStatus() {
    return _geofenceStatus;
  }

  void setStatus(String status) {
    _geofenceStatus = status;
  }

  StreamSubscription<GeofenceStatus>? getStatusStream() {
    return _geofenceStatusStream;
  }

  void setupGeofencing(String latitude, String longitude) {
    EasyGeofencing.startGeofenceService(
        pointedLatitude: latitude,
        pointedLongitude: longitude,
        radiusMeter: "1000.0",
        eventPeriodInSeconds: 60);
  }

  void killStreamAndService () {
    EasyGeofencing.stopGeofenceService();
    _geofenceStatusStream!.cancel();
  }

}