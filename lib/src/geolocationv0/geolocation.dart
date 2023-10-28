import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Geolocation {
  final int id;
  final String user;
  final String datetime;
  static List<List<double>> trajectory = [];

  const Geolocation({
    required this.id,
    required this.user,
    required this.datetime,
  });

  Map<String, dynamic> toMap() {
    return {
      'user': user,
      'datetime': datetime,
      'trajectory': jsonEncode(Geolocation.trajectory),
    };
  }

  Map<String, dynamic> fromMap() {
    return {
      'id': id,
      'user': user,
      'datetime': datetime,
      'trajectory': jsonEncode(Geolocation.trajectory),
    };
  }

    static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'database_user.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY)',
        );
      },
    );
  }
}








