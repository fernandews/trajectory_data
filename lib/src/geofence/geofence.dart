import 'package:geolocator/geolocator.dart';
import 'dart:developer' as dev;
import 'dart:async';
import 'package:trajectory_data/trajectory_data.dart';
import 'package:geofence_service/geofence_service.dart';

class Geofencing {
  // Create a [GeofenceService] instance and set options.
  final _geofenceService = GeofenceService.instance.setup(
      interval: 600000,
      accuracy: 100,
      loiteringDelayMs: 60000,
      statusChangeDelayMs: 120000,
      useActivityRecognition: false,
      allowMockLocations: false,
      printDevLog: false,
      geofenceRadiusSortType: GeofenceRadiusSortType.DESC);

  // Create a [Geofence] list.
  final _geofenceList = <Geofence>[
    Geofence(
      id: 'place_1',
      latitude: -23.700775,
      longitude: -46.696773,
      radius: [
        GeofenceRadius(id: 'radius_300m', length: 300),
      ],
    ),
  ];

  bool isRunningService = false;
  void addEventHandlers () {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _geofenceService.addGeofenceStatusChangeListener(_onGeofenceStatusChanged);
      _geofenceService.addLocationChangeListener(_onLocationChanged);
      _geofenceService.addLocationServicesStatusChangeListener(_onLocationServicesStatusChanged);
      _geofenceService.addStreamErrorListener(_onError);
      _geofenceService.start(_geofenceList).catchError(_onError);
    });
  }
}

void startCallback() {
  // The setTaskHandler function must be called to handle the task in the background.
  FlutterForegroundTask.setTaskHandler(FirstTaskHandler());
}

class FirstTaskHandler extends TaskHandler {
  SendPort? _sendPort;

  // Called when the task is started.
  @override
  Future<void> onStart(int user) async {
    startGettingLocation(user);

    // You can use the getData function to get the stored data.
    final customData =
    await FlutterForegroundTask.getData<String>(key: 'customData');
    dev.log('customData: $customData');
  }

  // Called every [interval] milliseconds in [ForegroundTaskOptions].
  @override
  Future<void> onRepeatEvent(DateTime timestamp, SendPort? sendPort) async {
    // Send data to the main isolate.
    sendPort?.send(timestamp);
  }


  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {

  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {

  }

  // Called when the notification button on the Android platform is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    dev.log('onNotificationButtonPressed >> $id');
  }

  // Called when the notification itself on the Android platform is pressed.
  //
  // "android.permission.SYSTEM_ALERT_WINDOW" permission must be granted for
  // this function to be called.
  @override
  void onNotificationPressed() {
    // Note that the app will only route to "/resume-route" when it is exited so
    // it will usually be necessary to send a message through the send port to
    // signal it to restore state when the app is already started.
    FlutterForegroundTask.launchApp("/resume-route");
    _sendPort?.send('onNotificationPressed');
  }
}

// This function is to be called when the geofence status is changed.
Future<void> _onGeofenceStatusChanged(
    Geofence geofence,
    GeofenceRadius geofenceRadius,
    GeofenceStatus geofenceStatus,
    Location location) async {
  print('geofence: ${geofence.toJson()}');
  print('geofenceRadius: ${geofenceRadius.toJson()}');
  print('geofenceStatus: ${geofenceStatus.toString()}');
}

// This function is to be called when the location has changed.
void _onLocationChanged(Location location) {
  print('location: ${location.toJson()}');
}

// This function is to be called when a location services status change occurs
// since the service was started.
void _onLocationServicesStatusChanged(bool status) {
  print('isLocationServicesEnabled: $status');
}

// This function is used to handle errors that occur in the service.
void _onError(error) {
  final errorCode = getErrorCodesFromError(error);
  if (errorCode == null) {
    print('Undefined error: $error');
    return;
  }

  print('ErrorCode: $errorCode');
}