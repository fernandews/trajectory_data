import 'package:sqflite/sqflite.dart';

class ApiServiceModel {
  String _databasePath = '';

  ApiServiceModel() {
    setDatabasePath();
  }

  void setDatabasePath() async {
    _databasePath = await getDatabasesPath();
  }

  String getDatabasePath () {
    return _databasePath;
  }
}








