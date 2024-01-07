import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/notification/notification_model.dart';

class NotificationController {

  NotificationController(this._notification_title, this._notification_text) {

  }
  final String _notification_title;
  final String _notification_text;

  static Future<Database> _openDatabase() async {
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


  void saveNotificationToLocalStorage(Database db) async {
    db.insert(
      'notifications',
      { 'notification_title': _notification_title.toString(),
        'notification_text': _notification_text.toString(),
      },
    );
  }

  Future<void> deleteNotifications(Database db) async {

      await db.delete(
        'notifications',
        where: '1 = 1',
      );
  }

  void saveNotifications() async{
    Database database = await _openDatabase();
    deleteNotifications(database);
    saveNotificationToLocalStorage(database);
    database.close;
  }

}