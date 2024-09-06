import 'package:cey_go/model/place.dart';
import 'package:cey_go/service/favourite_service.dart';
import 'package:cey_go/service/place_service.dart';
import 'package:cey_go/ui/Srearch%20Place%20Screen/search_place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Place>> _allPlacesFuture;
  List<Place> _filteredPlaces = [];
  final FavouritesService _favouritesService = FavouritesService();
  Map<String, bool> _favorites = {};

  @override
  void initState() {
    super.initState();
    _allPlacesFuture = PlacesApiService().fetchPlaces();
    _loadFavorites();
  }

  void _filterPlaces(String query) async {
    List<Place> allPlaces = await _allPlacesFuture;
    setState(() {
      if (query.isEmpty) {
        // Show initial random places
        _filteredPlaces = allPlaces.take(5).toList();
      } else {
        // Filter places based on the query
        _filteredPlaces = allPlaces
            .where((place) =>
                place.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _loadFavorites() async {
    List<String> favoriteIds = await _favouritesService.getFavorites();
    setState(() {
      _favorites =
          Map.fromIterable(favoriteIds, key: (id) => id, value: (_) => true);
    });
  }

  void _toggleFavorite(String placeId, bool isFavorite) async {
    await _favouritesService.toggleFavorite(placeId, !isFavorite);
    _loadFavorites(); // Reload favorites to update the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                color: Color(0xFFFFC100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find Destinations',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        letterSpacing: -0.32,
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset('assets/bell-pin-fill.svg'),
                      onPressed: () {
                        // Notification action
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/group-2.svg'),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterPlaces,
                        decoration: InputDecoration(
                          hintText: 'Search for Destinations',
                          border: InputBorder.none,
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Previous Search',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Anuradhapura'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Galle'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Kandy'),
                    SizedBox(width: 8),
                    _buildCategoryChip('Ella'),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Recommended for you',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              FutureBuilder<List<Place>>(
                future: _allPlacesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No places found'));
                  }

                  List<Place> placesToShow = _searchController.text.isEmpty
                      ? snapshot.data!.take(5).toList()
                      : _filteredPlaces;

                  return Column(
                    children: placesToShow.map((place) {
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Chip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.grey[300],
      padding: EdgeInsets.symmetric(horizontal: 8),
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
