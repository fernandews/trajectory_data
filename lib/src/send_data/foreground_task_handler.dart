import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trajectory_data/src/send_data/send_data_controller.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(ApiServiceTaskHandler());
}

class ApiServiceTaskHandler extends TaskHandler {
  SendDataController sendDataController = SendDataController();
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    print('ta chamando');
    sendDataController.sendDataToApi();
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

class ApiServiceTask {
  Future<bool> _startForegroundTask() async {
    print('start');
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: 'Mandando pra API',
        notificationText: 'A expectativa é que a geolocalização seja enviada',
        callback: startCallback,
      );
    }
  }

  Future<bool> stopApiService() {
    return FlutterForegroundTask.stopService();
  }

  void startApiService() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        id: 501,
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
}
