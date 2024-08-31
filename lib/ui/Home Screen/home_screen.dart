import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final double iconSize = 26;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFFE500), // Background Color
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: screenHeight * 0.05),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, Alex',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/qr-scan-regular-120-1.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        'assets/images/bell-pin-fill.png',
                        width: iconSize,
                        height: iconSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/group-2.png',
                      width: 21,
                      height: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for Destinations',
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Image.asset(
              'assets/images/new-elephant-sanctuary-will-provide-safe-home-for-elephants-retired-from-brutal-logging-industry.png',
              width: screenWidth,
              height: screenHeight * 0.25,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Places',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ...buildPlaceCards(
                context,
                'Galle',
                'Whispers of the ocean in colonial walls',
                'assets/images/card-1.png'),
            ...buildPlaceCards(
                context,
                'Ella',
                'Scenic vistas and tranquil trails in the clouds',
                'assets/images/card-1-2.png'),
            ...buildPlaceCards(
                context,
                'Anuradhapura',
                'Ancient roots, where history breathes tranquility',
                'assets/images/card-1-3.png'),
            ...buildPlaceCards(
                context,
                'Kandy',
                'Where sacred relics meet serene highlands',
                'assets/images/card-1-4.png'),
            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              bottomNavItem('assets/images/home-indicator.png', true),
              bottomNavItem('assets/images/frame-4.png', false),
              bottomNavItem('assets/images/frame-4.png', false),
              bottomNavItem('assets/images/frame-4.png', false),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> buildPlaceCards(BuildContext context, String title,
      String description, String imagePath) {
    return [
      Stack(
        children: [
          Image.asset(
            imagePath,
            width: MediaQuery.of(context).size.width - 30,
            height: 90,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 15,
            child: Text(
              description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            top: 15,
            right: 15,
            child: Image.asset(
              'assets/images/ellipse-47.png',
              width: 29,
              height: 29,
            ),
          ),
        ],
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.02),
    ];
  }

  Widget bottomNavItem(String assetName, bool isActive) {
    return Image.asset(
      assetName,
      width: iconSize,
      height: iconSize,
      color: isActive ? Colors.black : Colors.grey,
    );
  }
}
