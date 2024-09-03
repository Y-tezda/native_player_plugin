import Flutter
import UIKit

public class NativePlayerPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
      
      let factory = NativeVideoPlayerViewFactory(messenger: registrar.messenger())
      registrar.register(factory, withId: NativeVideoPlayerViewFactory.id)
      
      
        print("plugin loaded")
      


  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
