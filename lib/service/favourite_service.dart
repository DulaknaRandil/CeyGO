import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cey_go/model/place.dart';
import 'package:cey_go/service/place_service.dart';

class FavouritesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  Future<void> toggleFavorite(String placeId, bool isFavorite) async {
    if (user == null) return;

    final userFavoritesRef =
        _db.collection('users').doc(user!.uid).collection('favorites');

    if (isFavorite) {
      await userFavoritesRef.doc(placeId).set({});
    } else {
      await userFavoritesRef.doc(placeId).delete();
    }
  }

  Future<List<String>> getFavorites() async {
    if (user == null) return [];

    final userFavoritesRef =
        _db.collection('users').doc(user!.uid).collection('favorites');
    final snapshot = await userFavoritesRef.get();

    return snapshot.docs.map((doc) => doc.id).toList();
  }

  Future<List<Place>> getFavoritesPlaces() async {
    List<String> favoriteIds = await getFavorites();
    if (favoriteIds.isEmpty) return [];

    List<Place> favoritePlaces = [];
    final placesApiService = PlacesApiService();
    final allPlaces = await placesApiService.fetchPlaces();

    for (String id in favoriteIds) {
      final place = allPlaces.firstWhere((place) => place.id.toString() == id,
          orElse: () => Place(
                id: 0,
                name: '',
                description: '',
                imageUrl: '',
              ));
      favoritePlaces.add(place);
    }

    return favoritePlaces;
  }
}
