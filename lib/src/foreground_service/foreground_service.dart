import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trajectory_data/src/geolocation/geolocation.dart';
import 'package:trajectory_data/src/send_data/send_data.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {

    Geolocation.getGeolocation();

  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  void onNotificationButtonPressed(String id) {

  }

  @override
  void onNotificationPressed() {

  }
}

class TrajectoryDefinitions {

  TrajectoryDefinitions._();
  static final TrajectoryDefinitions _instance = TrajectoryDefinitions._();

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

  void _initForegroundTask() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 500,
        channelId: 'trajectory_service',
        channelName: 'trajectory_service_channel',
        channelDescription: '',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
          backgroundColor: Colors.orange,
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 60000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    _startForegroundTask();
  }

  Future<bool> _startForegroundTask() async {
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'TCC da Paula e Jana',
        notificationText: 'A expectativa é que a geolocalização seja capturada',
        callback: startCallback,
      );
    }
  }

  Future<bool> _stopForegroundTask() {
    return FlutterForegroundTask.stopService();
  }
}

void startServices() async {
  TrajectoryDefinitions trajectory = TrajectoryDefinitions._instance;
  await trajectory._requestPermissionForAndroid();
  trajectory._initForegroundTask();
  startApiService();
}

