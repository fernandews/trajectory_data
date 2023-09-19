import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trajectory_data/src/geolocation/geolocation.dart';
import 'package:trajectory_data/src/send_data/send_data.dart';
import 'package:workmanager/workmanager.dart';

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

    final userId = await FlutterForegroundTask.getData<int>(key: 'userId');
    Geolocation.getGeolocation(userId);

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
  }

  Future<bool> _startForegroundTask(int user) async {
    await FlutterForegroundTask.saveData(key: 'UserId', value: user);

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

void startServices(int user) async {
  print("Starting Geolocation Foreground Service");
  TrajectoryDefinitions trajectory = TrajectoryDefinitions._instance;
  SendInBackground send = SendInBackground.instance;
  await trajectory._requestPermissionForAndroid();
  trajectory._initForegroundTask();
  trajectory._startForegroundTask(user);
  send.startApiService();
  print("Geolocation Foreground Service started");
}

