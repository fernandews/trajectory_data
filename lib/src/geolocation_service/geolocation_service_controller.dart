import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'package:trajectory_data/src/geolocation_service/foreground_task_handler.dart';
import 'package:trajectory_data/src/geolocation_service/geolocation_service_model.dart';

class GeolocationServiceController {
  GeolocationServiceModel geolocator = GeolocationServiceModel();

  Future<void> _requestPermissionForAndroid() async {
    if (!Platform.isAndroid) {
      return;
    }

    if (!await FlutterForegroundTask.isIgnoringBatteryOptimizations) {
      await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    }

    final NotificationPermission notificationPermissionStatus =
    await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermissionStatus != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  Future<void> getTrajectoryData() async {
    List<double> currentLocation = await GeolocationServiceModel.determinePosition()

    geolocator.addToTrajectory(currentLocation);

    if (trajectory.length == 30) {
      // colocar no banco

      final Map<String, dynamic>? data = await User.getUserId(db);
      final String userId = data?['id'];
      final Geolocation newGeolocation = Geolocation(
        id: 0,
        user: userId,
        datetime: DateTime.now().toString(),
      );
      await insertDataInBackground(newGeolocation);
      trajectory.clear();
    }
    print(Geolocation.trajectory.toString());
  }
}