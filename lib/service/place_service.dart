import 'dart:convert';
import 'package:cey_go/model/place.dart';
import 'package:http/http.dart' as http;

class PlacesApiService {
  static const String apiUrl =
      'https://9pmiehzhag.execute-api.eu-north-1.amazonaws.com/prod/places';

  Future<List<Place>> fetchPlaces() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Failed to load places');
    }
  }
}
