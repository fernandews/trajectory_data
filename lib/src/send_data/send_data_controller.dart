import 'dart:convert';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';

class SendDataController {
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'geolocation.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE geolocations(id INTEGER PRIMARY KEY AUTOINCREMENT, user INTEGER, datetime TEXT, trajectory TEXT)',
        );
      },
    );
  }

  Future<Map<String, dynamic>?> getGeolocationData(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(
        'geolocations', limit: 1);

    if (maps.isNotEmpty) {
      return {
        'id': maps[0]['id'],
        'user': maps[0]['user'],
        'datetime': maps[0]['datetime'].toString(),
        'trajectory': List<List<double>>.from(
            jsonDecode(maps[0]['trajectory']).map((data) => List<double>.from(
                data))),
      };
    } else {
      return null;
    }
  }


//delete data from database
  Future<void> deleteGeolocation(Map<String, dynamic>? data) async {
    print('Data sent to API successfully!');
    if (data != null) {
      final id = data['id'];
      final db = await _openDatabase();
      await db.delete(
        'geolocations',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('delete successfully!');
    }
  }

//main function
  Future<int?> sendToApi(Map<String, dynamic>? data) async {
    if (data != null) {
      final jsonData = json.encode(data);
      final apiUrl = 'https://hye0htyjkl.execute-api.sa-east-1.amazonaws.com/versao-1/geolocation';
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        return null;
      }
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonData,
        );
        return response.statusCode;
      } catch (e) {
        print('Error sending data to API: $e');
      }
    }
  }

  Future<bool> sendDataToApi () async {
    print('dentro da sentData');
    final Database db = await _openDatabase();
    final Map<String, dynamic>? data = await getGeolocationData(db);
    final int? statusCode = await sendToApi(data);
    if (statusCode == 200) {
      await deleteGeolocation(data);
    }
    return Future.value(true);
  }
}