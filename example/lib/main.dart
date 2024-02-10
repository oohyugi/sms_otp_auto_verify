import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _otpCodeLength = 4;
  bool _isLoadingButton = false;
  bool _enableButton = false;
  String _otpCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final intRegex = RegExp(r'\d+', multiLine: true);
  TextEditingController textEditingController =
      new TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _getSignatureCode();
    _startListeningSms();
  }

  @override
  void dispose() {
    super.dispose();
    SmsVerification.stopListening();
  }

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Theme.of(context).primaryColor),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  /// get signature code
  _getSignatureCode() async {
    String? signature = await SmsVerification.getAppSignature();
    print("signature $signature");
  }

  /// listen sms
  _startListeningSms() {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        _otpCode = SmsVerification.getCode(message, intRegex);
        textEditingController.text = _otpCode;
        _onOtpCallBack(_otpCode, true);
      });
    });
  }

  _onSubmitOtp() {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onClickRetry() {
    _startListeningSms();
  }

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
      } else {
        _enableButton = false;
      }
    });
  }

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () {
      setState(() {
        _isLoadingButton = false;
        _enableButton = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification OTP Code $_otpCode Success")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFieldPin(
                      textController: textEditingController,
                      autoFocus: true,
                      codeLength: _otpCodeLength,
                      alignment: MainAxisAlignment.center,
                      defaultBoxSize: 46.0,
                      margin: 10,
                      selectedBoxSize: 46.0,
                      textStyle: TextStyle(fontSize: 16),
                      defaultDecoration: _pinPutDecoration.copyWith(
                          border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.6))),
                      selectedDecoration: _pinPutDecoration,
                      onChange: (code) {
                        _onOtpCallBack(code, false);
                      }),
                  SizedBox(
                    height: 32,
                  ),
                  Container(
                    width: double.maxFinite,
                    child: MaterialButton(
                      onPressed: _enableButton ? _onSubmitOtp : null,
                      child: _setUpButtonChild(),
                      color: Colors.blue,
                      disabledColor: Colors.blue[100],
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: TextButton(
                      onPressed: _onClickRetry,
                      child: Text(
                        "Retry",
                        style: TextStyle(color: Colors.orange),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        "Verify",
        style: TextStyle(color: Colors.white),
      );
    }
  }
}
