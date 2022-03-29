import 'package:flutter_project/domini/services/google_login_adpt.dart';
import 'package:flutter_project/domini/services/google_maps_adpt.dart';
import 'package:flutter_project/domini/services/google_places_adpt.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

void setUpLocator() {
  serviceLocator.registerLazySingleton<GoogleMapsAdpt>(() => GoogleMapsAdpt());
  serviceLocator.registerLazySingleton<GoogleLoginAdpt>(() => GoogleLoginAdpt());
  serviceLocator.registerLazySingleton<GooglePlaceAdpt>(() => GooglePlaceAdpt());
}


GoogleMapsAdpt get getMapsService {
  return serviceLocator<GoogleMapsAdpt>();
}

GoogleLoginAdpt get getLoginService {
  return serviceLocator<GoogleLoginAdpt>();
}

GooglePlaceAdpt get getPlaceService {
  return serviceLocator<GooglePlaceAdpt>();
}
