import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/domini/coordenada.dart';
import 'package:flutter_project/domini/ctrl_domain.dart';
import 'package:flutter_project/domini/rutes/routes_response.dart';
import 'package:flutter_project/domini/rutes/rutes_amb_carrega.dart';
import 'package:flutter_project/domini/services/happy_lungs_adpt.dart';
import 'package:flutter_project/interficie/constants.dart';
import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:flutter_project/interficie/page/profile_page.dart';
import 'package:flutter_project/libraries/flutter_google_maps/flutter_google_maps.dart';
import 'package:flutter_project/libraries/flutter_google_maps/src/core/route_response.dart';

class RutesEco {
  late CtrlDomain ctrlDomain;
  late RoutesResponse routesResponse;
  late RutesAmbCarrega rutesAmbCarrega;
  late HappyLungsAdpt happyLungsAdpt;

  RutesEco() {
    ctrlDomain = CtrlDomain();
    routesResponse = RoutesResponse.buit();
    rutesAmbCarrega = RutesAmbCarrega();
    happyLungsAdpt = HappyLungsAdpt();
  }

  /// Obtenim la ruta amb carregador original
  Future<RoutesResponse> obtenirRutaCarregador (GeoCoord origen, GeoCoord desti, double bateriaPerc, double consum) async{
    RoutesResponse result = RoutesResponse.buit();
    result = await rutesAmbCarrega.algorismeMillorRuta(origen, desti, bateriaPerc, consum);
    return result;
  }

  /// Obtenir waypoints eco propers
  Future<void> getEcoWaypoints(List<GeoCoord> coordRuta) async {
    for (int i = (coordRuta.length/10).round(); i < (coordRuta.length - (coordRuta.length/10).round()); i+= (coordRuta.length/10).round()) {
      double minDist = double.infinity, auxDist;
      GeoCoord ecoWayPoint = const GeoCoord(-1.0, -1.0);

      Map<double, GeoCoord> ecoCoords = await happyLungsAdpt.getEcoPoints(coordRuta[i]); //obtenim els punts ecològics de cada coordenada de la nostra ruta

      for (var eco in ecoCoords.entries) {
        auxDist = GoogleMap.of(ctrlPresentation.getMapKey())!.getDistance(eco.value, coordRuta[i]);

        if (auxDist < minDist) { // dins de les coords que ens retornen, només seleccionem aquella que està més a prop de la ruta original
          ecoWayPoint = eco.value;
          minDist = auxDist;
        }
      }

      //només afegir a llistat de waypoints eco si existeix punt ecologic a prop
      if (ecoWayPoint.latitude != -1.0 && ecoWayPoint.longitude != -1.0) {
        routesResponse.waypoints.add(ecoWayPoint);
      }
      else {
        routesResponse.waypoints.add(coordRuta[i]);
      }
    }
  }

  /// Obtenim les distancia, duracio i conjunt de coordenades de la ruta ecologica
  Future<void> fillEcoInfo (GeoCoord origen, GeoCoord desti) async {
    routesResponse.origen = origen;
    routesResponse.destino = desti;

    double totalDist = 0.0, totalDur = 0.0;
    RouteResponse routeInfo= await GoogleMap.of(ctrlPresentation.getMapKey())!.getInfoRoute(origen, desti, waypoints: routesResponse.waypoints);

    routesResponse.setDuration(routeInfo.durationMinutes!);
    routesResponse.setDistance(routeInfo.distanceMeters!);
  }

  void placeChargers(List<GeoCoord> chargers) {
    for (var element in chargers) {
      double nearest = double.infinity;
      int flag = -1;
      for (int i = 0; i < routesResponse.waypoints.length; ++i) {
        double dist = GoogleMap.of(ctrlPresentation.getMapKey())!.getDistance(element, routesResponse.waypoints.elementAt(i));
        if (dist < nearest) {
          flag = i;
          nearest = dist;
        }
      }

      if (flag != -1) {
        routesResponse.waypoints.insert(flag, element); // comprobar que este mas cerca del i-1 o i+1
      } else {
        routesResponse.waypoints.add(element);
      }
    }

  }

  /// Algorisme principal de trobada de ruta eco
  Future<RoutesResponse> algorismeEco (GeoCoord origen, GeoCoord desti, double bateriaPerc, double consum) async{
    RoutesResponse resultAmbCarrega = await obtenirRutaCarregador(origen, desti, bateriaPerc, consum);

    List<GeoCoord> chargers = resultAmbCarrega.waypoints;
    routesResponse.waypoints = List<GeoCoord>.empty(growable: true);

    await getEcoWaypoints(resultAmbCarrega.coords);

    placeChargers(chargers);

    await fillEcoInfo(origen, desti);

    return routesResponse;
  }
}