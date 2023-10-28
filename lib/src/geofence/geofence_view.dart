import 'package:flutter/material.dart';

import 'package:trajectory_data/src/geofence/geofence_controller.dart';

class GeofenceStatusWidget extends StatelessWidget {
  final GeofenceController geofenceController;
  const GeofenceStatusWidget({Key? key, required this.geofenceController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(geofenceController.getStatusToShow());
  }
}