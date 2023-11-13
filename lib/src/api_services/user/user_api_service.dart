import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/api_services/api_service_model.dart';
import 'package:trajectory_data/src/user/user_controller.dart';

class UserApiServiceController {
  final apiService = ApiServiceModel();
  //final user = UserController.getUserFromDatabaseOrInstance();

  Future<Database> _openUserDatabase() async {
    String path = join(apiService.getDatabasePath(), 'database_user.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, Userid TEXT)',
        );
      },
    );
  }

  Future<String?> getUserId() async {
    Database database = await _openUserDatabase();
    List<Map<String, dynamic>> users = await database.query('users');

    if (users.isNotEmpty) {
      final dynamic idValue = users[0]['id'];
      return idValue.toString();
    }
    return null;
  }

  void saveUserIdToLocalStorage(String id) async {
    Database database = await _openUserDatabase();
    database.insert(
      'users',
      { 'Userid': id.toString() },
    );
  }
}