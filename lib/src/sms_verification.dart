import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class SmsVerification {
  static const MethodChannel _channel =
      const MethodChannel('sms_otp_auto_verify');

  static Future<String?> startListeningSms() async {
    if (Platform.isAndroid) {
      try {
        final String result = await _channel.invokeMethod('startListening');
        print(result);
        return result;
      } catch (e) {
        return e.toString();
      }
    } else {
      return null;
    }
  }

  static Future<void> stopListening() {
    return _channel.invokeMethod('stopListening');
  }

  static Future<String?> getAppSignature() async {
    if (Platform.isAndroid) {
      final String signatureCode =
          await _channel.invokeMethod('getAppSignature');
      return signatureCode;
    } else {
      return null;
    }
  }
  static getCode(String? sms,RegExp regExp ) {
    if(sms!=null){
     return regExp.allMatches(sms).first.group(0);
    }else{
      return "";
    }
  }
}
