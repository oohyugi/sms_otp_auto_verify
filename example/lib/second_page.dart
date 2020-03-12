import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  SecondPage({Key key, this.otpCode}) : super(key: key);
  final String otpCode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Verification OTP Success $otpCode "),
    );
  }
}
