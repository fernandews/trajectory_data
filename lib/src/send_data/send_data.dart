import 'dart:convert';
import 'dart:async';
import 'package:trajectory_data/src/geolocation/geolocation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'package:connectivity/connectivity.dart';


//estabelece a conexão com o banco de dados
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

//faz um select no banco de dados
Future<Map<String, dynamic>?> getGeolocationData() async {

  final Database db = await _openDatabase();
  final List<Map<String, dynamic>> maps = await db.query('geolocations', limit: 1);

  if (maps.isNotEmpty) {
    return{
      'id': maps[0]['id'],
      'user':  maps[0]['user'],
      'datetime': maps[0]['datetime'].toString(),
      'trajectory':  List<List<double>>.from(jsonDecode(maps[0]['trajectory']).map((data) => List<double>.from(data))),
    };
  } else {
    return null;
  }
}

//delete data from database
Future<void> deleteGeolocation(int id) async {

  final db = await _openDatabase();
  await db.delete(
    'geolocations',
    where: 'id = ?',
    whereArgs: [id],
  );
}

//main function
Future<void> sendToApi() async {
  print('opa, comecei!!');
  final Map<String, dynamic>? data = await getGeolocationData();

  if (data != null) {
    final id = data['id'];
    final jsonData = json.encode(data);
    final apiUrl = 'https://hye0htyjkl.execute-api.sa-east-1.amazonaws.com/versao-1/geolocation';

    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonData,
      );
      if (response.statusCode == 200) {
            print('Data sent to API successfully!');
            deleteGeolocation(id);
      }
    } catch (e) {
      print('Error sending data to API: $e');
    }
  } else {
    print('No data found in the database.');
  }
  print('opa, acabei!!');

}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    sendToApi();
    return Future.value(true);
  });
}






