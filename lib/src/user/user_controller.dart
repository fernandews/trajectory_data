import 'package:trajectory_data/src/api_services/user/user_api_service.dart';
import 'package:trajectory_data/src/user/user_model.dart';

class UserController {
  static Future<User> getUserFromDatabaseOrInstance() async {
    User user = User.getUser();

    // user nao tinha um id na instancia
    if (user.getId() == user.getInitialId()) {
      UserApiServiceController apiService = UserApiServiceController();
      String? userId = await apiService.getUserId();

      if (userId != null) {
        // pegou do banco
        user.setId(userId);
      } else {
        // gerar um aleatório
        user.generateRandomId();
      }

      apiService.saveUserIdToLocalStorage(user.getId());
    }
    return user;
  }


}