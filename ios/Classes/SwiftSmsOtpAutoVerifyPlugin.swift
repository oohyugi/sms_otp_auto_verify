import Flutter
import UIKit

public class SwiftSmsOtpAutoVerifyPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sms_otp_auto_verify", binaryMessenger: registrar.messenger())
    let instance = SwiftSmsOtpAutoVerifyPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
