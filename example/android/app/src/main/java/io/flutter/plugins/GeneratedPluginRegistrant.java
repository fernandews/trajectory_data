package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.connectivity.ConnectivityPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin connectivity, io.flutter.plugins.connectivity.ConnectivityPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.pravera.fl_location.FlLocationPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin fl_location, com.pravera.fl_location.FlLocationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.pravera.flutter_activity_recognition.FlutterActivityRecognitionPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_activity_recognition, com.pravera.flutter_activity_recognition.FlutterActivityRecognitionPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new id.flutter.flutter_background_service.FlutterBackgroundServicePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_background_service_android, id.flutter.flutter_background_service.FlutterBackgroundServicePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_foreground_task, com.pravera.flutter_foreground_task.FlutterForegroundTaskPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.pravera.geofence_service.GeofenceServicePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin geofence_service, com.pravera.geofence_service.GeofenceServicePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.baseflow.geolocator.GeolocatorPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin geolocator_android, com.baseflow.geolocator.GeolocatorPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin shared_preferences_android, io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin sqflite, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new be.tramckrijte.workmanager.WorkmanagerPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin workmanager, be.tramckrijte.workmanager.WorkmanagerPlugin", e);
    }
  }
}