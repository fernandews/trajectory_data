import 'dart:io';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trajectory_data/src/api_services/trajectory/trajectory_api_service.dart';

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
    List<double> currentLocation = await geolocator.determinePosition();
    print("capturing geolocation");
    geolocator.addToTrajectory(currentLocation);
    if (geolocator.getTrajectory().length == 30) {
      TrajectoryApiServiceController apiService = TrajectoryApiServiceController.getTrajectoryApiService();
      await apiService.insertTrajectoryDataInInternalStorage(geolocator.getTrajectory());

      geolocator.clearTrajectory();
    }
    print(geolocator.getTrajectory());

  }
}