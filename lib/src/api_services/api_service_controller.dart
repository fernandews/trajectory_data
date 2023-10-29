import 'dart:convert';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/api_services/api_service_model.dart';
import 'package:trajectory_data/src/user/user_model.dart';

class ApiServiceController {
  final apiService = ApiServiceModel();
  final user = User.getUser();

  // lidar com o user
  Future<Database> openUserDatabase() async {
    String path = join(apiService.getDatabasePath(), 'database_user.db');
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