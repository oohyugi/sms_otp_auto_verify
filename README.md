# sms_otp_auto_verify

A new Flutter plugin to enter a digit code usually in cases of Sms Otp Code. and provide SMS Auto Fill using library SMS Retriever API.



<img width="220px" alt="Example App " src="https://raw.githubusercontent.com/oohyugi/sms_otp_auto_verify/master/screenshots/img.jpg"/>

## Getting Started
### Import package
```dart
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
```
### Get Signature Code
```dart
  String signature = await SmsRetrieved.getAppSignature();
```
### Add Widget
codeLength must equals with Sms OTP Code length

```dart
OtpListTextField(
                  filled: true,
                  filledColor: Colors.grey[100],
                  codeLength: _otpCodeLength,
                  boxSize: 48,
                  onOtpCallback: (code, isAutofill) =>
                      _onOtpCallBack(code, isAutofill),
                )
```

### Listen result from OtpListTextField
```dart
_onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _enableButton = false;
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _enableButton = true;
        _isLoadingButton = false;
      }else{
        _enableButton = false;
      }
    });
  }
```

### Example Sms
```html
<#> ExampleApp: Your code is 5664
   r64Iw/6mD1D
```


