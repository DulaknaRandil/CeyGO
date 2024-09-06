import 'package:cey_go/ui/New%20Password%20Screen/new_password_screen.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final _pinController = TextEditingController();
  final _functions = FirebaseFunctions.instance;

  void _verifyPin() async {
    final pin = _pinController.text;

    if (pin.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the PIN')),
      );
      return;
    }

    try {
      final result =
          await _functions.httpsCallable('validatePin').call(<String, dynamic>{
        'pin': pin,
      });

      if (result.data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PIN verified successfully')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewPasswordScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid PIN')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying PIN: ${e}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              IconButton(
                icon: SvgPicture.asset('assets/back-button.svg'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 200),
              Center(
                child: Column(
                  children: [
                    Text(
                      "Email Verification",
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        height: 1.2,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Enter the PIN sent to your email",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.black.withOpacity(0.6),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _pinController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(color: Colors.black),
                              cursorColor: Colors.black.withOpacity(0.6),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter PIN',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1,
                                  color: Colors.black.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _verifyPin,
                        child: Text(
                          'Verify PIN',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
