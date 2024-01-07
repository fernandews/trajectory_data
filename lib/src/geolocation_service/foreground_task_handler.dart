import 'dart:io';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:trajectory_data/src/geolocation_service/geolocation_service_controller.dart';
import 'package:trajectory_data/src/notification/notification_model.dart';

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(GeolocationServiceTaskHandler());
}

class GeolocationServiceTaskHandler extends TaskHandler {
  final geolocationServiceController = GeolocationServiceController();
  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
  }

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    geolocationServiceController.getTrajectoryData();
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

class GeolocationServiceTask {
  Future<bool> _startForegroundTask() async {
    print('start capture');
    NotificationModel notification = await getNotification();
    if (await FlutterForegroundTask.isRunningService) {
      return FlutterForegroundTask.restartService();
    } else {
      return FlutterForegroundTask.startService(
        notificationTitle: notification.title,
        notificationText: notification.text,
        callback: startCallback,
      );
    }
  }

  Future<bool> stopGeolocationService() {
    return FlutterForegroundTask.stopService();
  }

  void startGeolocationService() async {
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
        interval: 30000,
        isOnceEvent: false,
        autoRunOnBoot: true,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
    _startForegroundTask();
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_notification.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notifications(id INTEGER PRIMARY KEY AUTOINCREMENT, notification_title TEXT, notification_text TEX)',
        );
      },
    );
  }

  Future<NotificationModel> getNotification() async {
    Database database = await _openDatabase();
    List<Map<String, dynamic>> map = await database.query('notifications');
      NotificationModel notification = NotificationModel(
        map[0]['notification_title'],
        map[0]['notification_text'],
      );
      return notification;

  }
}
