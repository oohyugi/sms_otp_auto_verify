#import "SmsOtpAutoVerifyPlugin.h"
#if __has_include(<sms_otp_auto_verify/sms_otp_auto_verify-Swift.h>)
#import <sms_otp_auto_verify/sms_otp_auto_verify-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "sms_otp_auto_verify-Swift.h"
#endif

@implementation SmsOtpAutoVerifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSmsOtpAutoVerifyPlugin registerWithRegistrar:registrar];
}
@end
