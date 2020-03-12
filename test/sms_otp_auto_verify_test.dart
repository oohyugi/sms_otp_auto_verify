import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sms_otp_auto_verify/src/sms_retrieved.dart';

void main() {
  const MethodChannel channel = MethodChannel('sms_otp_auto_verify');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SmsRetrieved.platformVersion, '42');
  });
}
