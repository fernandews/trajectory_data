import UIKit
import Flutter
import background_locator

func registerPlugins(registry: FlutterPluginRegistry) -> () {
    if (!registry.hasPlugin("BackgroundLocatorPlugin")) {
        GeneratedPluginRegistrant.register(with: registry)
    }
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // here
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate

     BackgroundLocatorPlugin.setPluginRegistrantCallback(registerPlugins)
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}