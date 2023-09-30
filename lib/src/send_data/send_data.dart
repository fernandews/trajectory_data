import 'dart:convert';
import 'dart:async';
import 'package:trajectory_data/src/geolocation/geolocation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:connectivity/connectivity.dart';



class SendInBackground {

  SendInBackground._();
  static final SendInBackground _instance = SendInBackground._();

  static SendInBackground get instance =>
      _instance; //establishes connection to the database
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
}
  void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {

      SendInBackground send = SendInBackground._instance;
      final Database db = await send._openDatabase();
      final Map<String, dynamic>? data = await send.getGeolocationData(db);
      final int? statusCode = await send.sendToApi(data);

      if (statusCode == 200) {
        await send.deleteGeolocation(data);
      }
      return Future.value(true);
    });
  }



void startApiService() {
  Workmanager().initialize(callbackDispatcher);
  Workmanager().registerPeriodicTask(
    "send_to_api_task",
    "simplePeriodicTask",
    inputData: <String, dynamic>{},
    frequency: Duration(minutes: 15),
  );
}




