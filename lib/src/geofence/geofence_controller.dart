import 'package:easy_geofencing/easy_geofencing.dart';
import 'package:easy_geofencing/enums/geofence_status.dart';

import 'package:trajectory_data/src/geofence/geofence_model.dart';
import 'package:trajectory_data/src/geolocation_service/foreground_task_handler.dart';
import 'package:trajectory_data/src/send_data/send_data_controller.dart';

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
    var geolocationService = GeolocationServiceTask();

    geofence.setupGeofencing(_latitude, _longitude);

    statusStream ??= EasyGeofencing.getGeofenceStream()!
        .listen((GeofenceStatus status) {
      if (geofence.getStatus() != status.toString()) {
        geofence.setStatus(status.toString());
        if (status.toString() == GeofenceStatus.enter.toString()) {
          geolocationService.startGeolocationService();
          startApiService();
        }
        if (status.toString() == GeofenceStatus.exit.toString()) {
          geolocationService.stopGeolocationService();
        }
      }
    });
  }


  void stopGeofencing () {
    _activeGeofence.killStreamAndService();
  }
}