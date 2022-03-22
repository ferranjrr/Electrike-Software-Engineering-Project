import 'package:google_geocoding/google_geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tuple/tuple.dart';

class GoogleMapsAdpt {
  static final _instance = GoogleMapsAdpt._internal();
  var googleGeocoding = GoogleGeocoding("***REMOVED***");

  factory GoogleMapsAdpt() {
    return _instance;
  }

  GoogleMapsAdpt._internal();

   ///@post: Retorna la direcció legible donada la coordenada amb la latitud i longitud
  Future<String> reverseCoding(double lat, double lng) async {
    String result = googleGeocoding.geocoding.getReverse(LatLon(lat, lng)).toString();
    return result;
  }

  Future<void> adressCoding(String adreca) async {
    var result = await googleGeocoding.geocoding.get("1600 Amphitheatre", null);
  }


}