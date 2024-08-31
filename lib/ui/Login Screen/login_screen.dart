import 'package:cey_go/ui/Home%20Screen/home_screen.dart';
import 'package:cey_go/ui/SignUp%20Screen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.265),
              Text(
                'Welcome',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  height: 1.2,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Login to your account',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  height: 1.2,
                  color: Colors.black.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.05),
              buildTextField('Email Address', Icons.email, false),
              SizedBox(height: 20),
              buildTextField('Password', Icons.lock, true),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => HomeScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.2, vertical: 12),
                ),
                child: Text(
                  'Log in',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Or continue with',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  height: 1.2,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialButton('assets/images/google.png'),
                  SizedBox(width: 20),
                  socialButton('assets/images/facebook.png'),
                ],
              ),
              SizedBox(height: screenHeight * 0.1),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: 'Don’t have an account? ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Register',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, IconData icon, bool obscureText) {
    return TextField(
      obscureText: obscureText,
      style: TextStyle(color: Colors.black), // Text color is black while typing
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.black.withOpacity(0.6),
        ),
        suffixIcon: obscureText
            ? IconButton(
                icon: Icon(Icons.visibility_off),
                color: Colors.black.withOpacity(0.6),
                onPressed: () {},
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
      cursorColor: Colors.black, // Cursor color is black
    );
  }

  Widget socialButton(String imagePath) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey),
        ),
        child: Image.asset(
          imagePath,
          width: 35,
          height: 35,
        ),
      ),
    );
  }
}
