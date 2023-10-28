import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/user/user.dart';
import 'package:trajectory_data/src/internal_persistence/internal_persistence.dart';


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


  // request de current position, insert in a list e check the time to send the list
  static Future<void> getGeolocation() async {
    Position position = await determinePosition();
    List<double> geolocation = [position.latitude, position.longitude];
    Geolocation.trajectory.add(geolocation);
    if (Geolocation.trajectory.length == 30) {
      final Database db = await Geolocation._openDatabase();
      final Map<String, dynamic>? data = await User.getUserId(db);
      final String userId = data?['id'];
      final Geolocation newGeolocation = Geolocation(
        id: 0,
        user: userId,
        datetime: DateTime.now().toString(),
      );
      await insertDataInBackground(newGeolocation);
      Geolocation.trajectory.clear();
    }
    print(Geolocation.trajectory.toString());
  }

  //check permission e capture the current position
  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }
    return Geolocator.getCurrentPosition();
  }
}








