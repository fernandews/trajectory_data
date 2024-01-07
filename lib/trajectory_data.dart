import 'package:trajectory_data/src/geofence/geofence_controller.dart';
import 'package:trajectory_data/src/api_services/user/user_api_service.dart';
import 'package:trajectory_data/src/notification/notification_controller.dart';

export 'package:trajectory_data/src/geofence/geofence_controller.dart';
export 'package:trajectory_data/src/api_services/trajectory/trajectory_api_view.dart';
export 'package:trajectory_data/src/geolocation_service/foreground_task_handler.dart';


class TrajectoryData {
  final String id;
  final String _latitude;
  final String _longitude;
  final String _notificationTitle;
  final String _notificationText;

  TrajectoryData({
      this.id = '',
      required String latitude,
      required String longitude,
      required String notificationTitle,
      required String notificationText
      })

      : _latitude = latitude,
        _longitude = longitude,
        _notificationTitle = notificationTitle,
        _notificationText = notificationText {
    if (id.isNotEmpty && id != '') {
      UserApiServiceController apiService = UserApiServiceController();
      apiService.saveUserIdToLocalStorage(id);
    }
    final NotificationController notification = NotificationController(notificationTitle, notificationText);
    notification.saveNotifications();
    final GeofenceController geofence = GeofenceController(_latitude, _longitude);
  }

}
