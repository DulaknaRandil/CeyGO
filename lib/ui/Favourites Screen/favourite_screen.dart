import 'dart:ui';
import 'package:cey_go/model/place.dart';
import 'package:cey_go/service/favourite_service.dart';
import 'package:cey_go/service/place_service.dart';
import 'package:cey_go/ui/Srearch%20Place%20Screen/search_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FavouritesScreen extends StatefulWidget {
  @override
  _FavouritesScreenState createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late Future<List<Place>> futureFavorites;
  final FavouritesService _favouritesService = FavouritesService();
  Map<String, bool> _favorites = {}; // Track favorite status

  @override
  void initState() {
    super.initState();
    futureFavorites = Future.value([]); // Initialize with an empty list
    _loadFavorites();
  }

  void _loadFavorites() async {
    List<String> favoriteIds = await _favouritesService.getFavorites();
    setState(() {
      _favorites =
          Map.fromIterable(favoriteIds, key: (id) => id, value: (_) => true);
      futureFavorites = _favouritesService.getFavoritesPlaces();
    });
  }

  void _toggleFavorite(String placeId, bool isFavorite) async {
    await _favouritesService.toggleFavorite(placeId, !isFavorite);
    // Reload favorites and places to reflect the updated state
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Favorites',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            GestureDetector(
              onTap: () {
                // Notification action
              },
              child: SvgPicture.asset(
                'assets/bell-pin-fill.svg',
                color: Colors.black,
                height: 24, // Adjust height as needed
                width: 24, // Adjust width as needed
              ),
            ),
          ],
        ),
        backgroundColor: Color(0xFFFFC100),
      ),
      body: FutureBuilder<List<Place>>(
        future: futureFavorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No favorites added'));
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                      bottom: Radius.circular(0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Favorite Places',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Column(
                        children: snapshot.data!.map((place) {
                          bool isFavorite =
                              _favorites[place.id.toString()] ?? false;
                          return _buildPlaceCard(
                            place.name,
                            place.description,
                            place.imageUrl,
                            isFavorite,
                            place.id.toString(),
                            context,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlaceCard(
    String title,
    String subtitle,
    String assetPath,
    bool isFavorite,
    String placeId,
    BuildContext context,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to SearchedPlaceScreen with the place details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchedPlaceScreen(
                placeName: title,
                placeImage: assetPath,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(assetPath),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 100,
          child: Stack(
            children: [
              Positioned(
                bottom: 16,
                left: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0.5, 0.5),
                            color: Colors.black,
                            blurRadius: 0.5,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    _toggleFavorite(placeId, isFavorite);
                  },
                  child: CircleAvatar(
                    radius: 14.5,
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
