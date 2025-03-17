import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sklr/database/database.dart';
import 'package:sklr/database/userIdStorage.dart';
import 'package:sklr/Home/home.dart';
import 'package:sklr/Auth/phoneNumber.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../database/models.dart';

class PhoneVerify extends StatefulWidget {
  final String code;
  final String number;

  const PhoneVerify({required this.code, required this.number, super.key});

  @override
  State<StatefulWidget> createState() => VerifyState();
}
//phone verify page done  
class VerifyState extends State<PhoneVerify> {
  String? otp;
  bool otpFilled = false;
  final TextEditingController otpController = TextEditingController();
  int remaining = 60; // 1 minute to enter otp?
  Timer? timer;
  bool enableResend = false;

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  void onOTPChanged(String value) {
    otp = value;
    setState(() {
      otpFilled = value.length == 4;
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remaining > 0) {
        setState((){
          remaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  void resendOTP() {
    // logic for sending OTP goes here
    setState(() {
      remaining = 60;
      enableResend = false;
    });
    startTimer();
  }

  void verifyOTP() async {
    if (otpFilled) {
      // verification of OTP goes here
      if (otp == '1234') { // local testing, no verification
        final int? userId = await UserIdStorage.getLoggedInUserId();

        if (userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: const Text('Failed to fetch valid session'))
          );
          return;
        }

        // make patch request to backend
        DatabaseResponse result = await DatabaseHelper.patchUser(userId, {
          'phone_number': '+${widget.code} ${widget.number}'
        } as Map<String, dynamic>);

        if (result.success) {
          // award 1 currency for verifying  phone number
          final bool awarded = await DatabaseHelper.awardUser(userId);

          if (awarded) {
            Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()), 
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('You already have a verified phone number!'))
            );
          }
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result.data['error']))
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Please enter a valid code'))
        );
      }
    } 
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PhoneAppbar(),
      body: Stack(
        children: [
          Center(
            child: Column(
              spacing: 16,
              children: [
                SizedBox(height: 50), 
                Image.asset(
                  'assets/images/illustration-smartphone.png',
                  height: 250,
                  width: 250,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Verify Your Phone',
                  style: GoogleFonts.mulish(
                    color: Color(0xff053742),
                    fontSize: 32,
                    fontWeight: FontWeight.w600
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Please enter the 4 digit code sent to\n',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Color(0xff88879C),
                            fontSize: 16,
                          )
                        ),
                      ),
                      TextSpan(
                        text: '+${widget.code} ${widget.number}',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Color(0xff3204FF),
                            fontSize: 16
                          )
                        )
                      ),
                    ],
                  )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Expanded(
                        child: PinCodeTextField(
                          appContext: context,
                          length: 4,
                          controller: otpController,
                          onChanged: onOTPChanged,
                          keyboardType: TextInputType.number,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.underline,
                            fieldHeight: 75,
                            fieldWidth: 75,
                            activeColor: Colors.blue,
                            inactiveColor: Colors.grey,
                            selectedColor: Colors.black,
                          ),
                          enableActiveFill: false,
                        )
                      )
                    ]
                  )
                ),
                Text(
                  formatTime(remaining),
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      color: Color(0xff88879C),
                      fontSize: 16,
                    )
                  )
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Didn\'t receive the code? ',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: Color(0xff88879C),
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          )
                        ),
                      ),
                      TextSpan(
                        text: 'Resend',
                        style: GoogleFonts.mulish(
                          textStyle: TextStyle(
                            color: enableResend ? Color(0xff3204FF) : Color(0xff88879C),
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            if (enableResend) {
                              resendOTP();
                            }
                          },
                      )
                    ]
                  )
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton(
                          onPressed: () {
                            // otp is filled & active "session" is ongoing
                            if (otpFilled && !enableResend) {
                              verifyOTP();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: otpFilled && !enableResend ? Color(0xff3204FF) : Colors.grey[350],
                            padding: EdgeInsets.all(24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)
                            )
                          ),
                          child: Text(
                            'Verify',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                color: otpFilled && !enableResend ? Colors.white : Color(0xff88879C),
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              )
                            )
                          )
                        )
                      ) 
                    )
                  ]
                ),
              ]
            )
          )
        ],
      )
    );
  }
}

String formatTime(int seconds) {
  int minutes = seconds ~/ 60;
  int remaining = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remaining.toString().padLeft(2, '0')}';
}