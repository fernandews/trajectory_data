import 'package:trajectory_data/src/geofence/geofence_model.dart';
import 'package:trajectory_data/src/foreground_service/foreground_service.dart';

import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

class GeofenceController {
  GeofenceController(this._latitude, this._longitude) {
    startGeofencing();
  }

  final String _latitude;
  final String _longitude;
  final Geofence _activeGeofence = Geofence();

  void startGeofencing() {
    var geofence = _activeGeofence;
    var statusStream = geofence.getStatusStream();

    geofence.setupGeofencing(_latitude, _longitude);

    statusStream ??= EasyGeofencing.getGeofenceStream()!
        .listen((GeofenceStatus status) {
      if (geofence.getStatus() != status.toString()) {
        geofence.setStatus(status.toString());
        if (status.toString() == GeofenceStatus.enter.toString()) {
          startServices();
        }
      }
    });
  }

  String getStatusToShow() {
    if (_activeGeofence.getStatus() == GeofenceStatus.enter.toString()) {
      return "O usuário está na cerca";
    }
    return "O usuário está fora da cerca";
  }

  void stopGeofencing () {
    _activeGeofence.killStreamAndService();
  }
}