import 'package:sqflite/sqflite.dart';
import 'package:trajectory_data/src/api_service/api_service_controller.dart';

class UserController {
  Future<String?> getUserId() async {
    Database database = await ApiServiceController.openUserDatabase();
    List<Map<String, dynamic>> users = await database.query('users');

    if (users.isNotEmpty) {
      final dynamic idValue = users[0]['id'];
      return idValue.toString();
    }
    return null;
  }

}