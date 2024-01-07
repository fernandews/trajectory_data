import 'dart:convert';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/api_services/api_service_model.dart';
import 'package:trajectory_data/src/api_services/trajectory/trajectory_data_mappers.dart';
import 'package:trajectory_data/src/user/user_controller.dart';

class TrajectoryApiServiceController {
  final apiService = ApiServiceModel();

  String _feedbackMessage = 'Parece que ainda não tentamos enviar nada.';

  TrajectoryApiServiceController._();
  static TrajectoryApiServiceController? _instance;

  static TrajectoryApiServiceController getTrajectoryApiService() {
    _instance ??= TrajectoryApiServiceController._();
    return _instance!;
  }

  Future<void> insertTrajectoryDataInInternalStorage(List<List<double>> trajectoryList) {
    //print('tentando inserir dados no internal storage');
    return _insertData(trajectoryList);
  }

  Future<void> _insertData(List<List<double>> trajectoryList) async {
    final Database db = await _openTrajectoryDatabase();
    //print(db.toString());
    final user = await UserController.getUserFromDatabaseOrInstance();
    //print(user.toString());
    TrajectoryData trajectoryDict = TrajectoryData(user.getId(), trajectoryList);
    //print(trajectoryDict.toString());
    try {
        var rowInserted = await db.insert(
          'geolocations',
          trajectoryDict.mapToJson(),
        );

        if (rowInserted != -1) {
          _feedbackMessage = 'Última inserção feita com sucesso.';
        } else {
          _feedbackMessage = 'Última inserção falhou.';
        }
    } catch (e) {
        print('Error inserting data: $e');
    } finally {
        await db.close(); // Close the database after the operation
    }
  }

  Future<Database> _openTrajectoryDatabase() async {
    String path = join(apiService.getDatabasePath(), 'geolocation.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE geolocations(id INTEGER PRIMARY KEY AUTOINCREMENT, user TEXT, datetime TEXT, trajectory TEXT)',
        );
      },
    );
  }

  String getFeedbackMessage() {
    return _feedbackMessage;
  }
}