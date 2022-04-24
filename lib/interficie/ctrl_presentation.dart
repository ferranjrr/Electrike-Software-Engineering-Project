import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/domini/coordenada.dart';
import 'package:flutter_project/domini/ctrl_domain.dart';
import 'package:flutter_project/domini/services/google_login_adpt.dart';
import 'package:flutter_project/domini/services/service_locator.dart';
import 'package:flutter_project/generated/l10n.dart';
import 'package:flutter_project/interficie/page/profile_page.dart';
import 'package:flutter_project/interficie/widget/edit_car_arguments.dart';
import 'package:flutter_project/libraries/flutter_google_maps/flutter_google_maps.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';

class CtrlPresentation {
  static final CtrlPresentation _singleton = CtrlPresentation._internal();
  CtrlDomain ctrlDomain = CtrlDomain();
  factory CtrlPresentation() {
    return _singleton;
  }
  CtrlPresentation._internal();

  String email = "";
  String name = "";
  String photoUrl = "";
  List<Coordenada> favs = <Coordenada>[];

  //intercambiar vista
  _showNotLogDialog(BuildContext context) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.BOTTOMSLIDE,
      title: "You aren't logged",//todo: S.of(context).alertSureDeleteCarTitle,
      desc: "You aren't logged so you don't have access to this screen because It would be empty.",//todo: S.of(context).alertSureDeleteCarContent,
      btnOkOnPress: () {},
      headerAnimationLoop: false,
    ).show();
  }

  void toMainPage(BuildContext context){
    Navigator.pushReplacementNamed(
      context,
      '/',
    );
  }

  toProfilePage(BuildContext context) {
    Navigator.pushReplacementNamed(
      context,
      '/profile',
    );
  }

  void toGaragePage(BuildContext context){
    if(email == "") {
      _showNotLogDialog(context);
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/garage',
      );
    }
  }

  void toFavouritesPage(BuildContext context){
    if(email == "") {
      _showNotLogDialog(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/favourites',
      );
    }
  }

  void toRewardsPage(BuildContext context){
    if(email == "") {
      _showNotLogDialog(context);
    } else {
      Navigator.pushReplacementNamed(
        context,
        '/rewards',
      );
    }
  }

  void toInfoAppPage(BuildContext context){
    Navigator.pushReplacementNamed(
      context,
      '/info',
    );
  }

  void toFormCar(BuildContext context) {
    if(email == ""){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: S.of(context).login,
        desc: S.of(context).toAddCarLogin,
        btnCancelOnPress: () {},
        btnOkIcon: (Icons.login),
        btnOkText: S.of(context).login,
        btnOkOnPress: () {
          signInRoutine(context);
        },

        headerAnimationLoop: false,
      ).show();
    }
    else{
      Navigator.pushNamed(
        context,
        '/newCar',
      );
    }
  }

  void toEditCar(BuildContext context, List<String> car) {
    Navigator.pop(context);
      Navigator.pushNamed(
        context,
        '/editCar',
        arguments: EditCarArguments(car),
      );
  }

  void toChartPage(BuildContext context, String pointTitle){
    Navigator.pushNamed(
      context,
      '/chart',
      arguments: pointTitle, //TODO: cosas de traducciones?
    );
  }
  //USER INFO FUNCTIONS
  String getCurrentUsername(BuildContext context){
    //TODO: CALL DOMAIN FUNCTION
    //String username = ctrlDomain.getCurrentUsername();
    if(name == "") name = S.of(context).clickToLogin;
    return name;
  }

  String getCurrentUserMail() {
    //TODO: CALL DOMAIN FUNCTION
    //String mail = ctrlDomain.getCurrentUserMail();
    return email;
  }

  void mailto() async {
    String _url = "mailto:electrike.official@gmail.com?subject=Help&body=Hi%20Electrike%20team!";
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  getCarsList() {
    return ctrlDomain.infoAllVUser();
  }

  List<Coordenada> getChargePointList() {
    //return chargePointList;
    return ctrlDomain.coordPuntsCarrega;
  }

  getBicingPointList() {
    return ctrlDomain.coordBicings;
  }

  Future<List<String>> getBrandList() {
    return ctrlDomain.getAllBrands();
  }

  String getUserImage() {
    if(photoUrl == "") photoUrl = "https://avatars.githubusercontent.com/u/75260498?v=4&auto=format&fit=crop&w=5&q=80";
    return photoUrl;
  }

  void signInRoutine(BuildContext context) async {
    Navigator.of(context).pop();
    await serviceLocator<GoogleLoginAdpt>().login();
  }

  void logoutRoutine(BuildContext context) async {
    if(email == "") {
      _showNotLogDialog(context);
    } else {
      resetUserValues();
      toMainPage(context);
      await serviceLocator<GoogleLoginAdpt>().logout();
    }
  }

  void resetUserValues() {
    email = "";
    name= "";
    photoUrl= "";
  }

  void setUserValues(name, email, photoUrl) {
     this.name = name;
     this.email = email;
     this.photoUrl = photoUrl;
   }

  Future<List<String>> getModelList(String brand) {
    return ctrlDomain.getAllModels(brand);
  }

  Future<List<String>> getInfoBicing(double lat, double long) {
    return ctrlDomain.getInfoBicing(lat, long);
  }

  List<String> getInfoCharger(double lat, double long) {
    return ctrlDomain.getInfoCharger(lat, long);
  }

  List<String> getInfoModel(String text) {
    return ctrlDomain.getCarModelInfo(text);
  }

  late GlobalKey<GoogleMapStateBase> _key;
  bool _googleMapInit = false;

  void setMapKey(GlobalKey<GoogleMapStateBase> key) {
    _googleMapInit = true;
    _key = key;
  }

  GlobalKey<GoogleMapStateBase> getMapKey() {
    return _key;
  }

  bool getGoogleMapKeyState() => _googleMapInit;

  void makeRoute(String destination){
    Location location = Location();

    location.getLocation().then((value) {
      String origin = value.latitude.toString() + "," + value.longitude.toString();

      GoogleMap.of(getMapKey())?.addDirection(
          origin,
          destination,
          startLabel: '1',
          startInfo: 'Origin',
          endIcon: 'assets/images/rolls_royce.png',
          endInfo: 'Destination'
      );

    });
  }

  void moveCameraToLocation() {
    Location location = Location();

    location.getLocation().then((value) {
      double? lat = value.latitude;
      double? lng = value.longitude;
      GoogleMap.of(getMapKey())?.moveCamera(GeoCoord(lat!, lng!), zoom: 17.5);
    });
  }
  void moveCameraToSpecificLocation(BuildContext context, double? lat, double? lng) {
    //used to move camera to specific chargers or points
    //todo: a veces funciona, otras no, no tengo ni la menor idea de porque.
      toMainPage(context);
      Future.delayed(const Duration(milliseconds: 1000), () {
        GoogleMap.of(getMapKey())?.moveCamera(GeoCoord(lat!, lng!), zoom: 17.5);
      });

  }

  bool isAFavPoint(double latitud, double longitud) {
    return ctrlDomain.isAFavPoint(latitud, longitud);
  }

  void loveClicked(BuildContext context, double latitud, double longitud) {
    if(email == ""){
      AwesomeDialog(
        context: context,
        dialogType: DialogType.INFO,
        animType: AnimType.BOTTOMSLIDE,
        title: S.of(context).login,
        desc: S.of(context).toAddFavLogin,
        btnCancelOnPress: () {},
        btnOkIcon: (Icons.login),
        btnOkText: S.of(context).login,
        btnOkOnPress: () {
          signInRoutine(context);
        },

        headerAnimationLoop: false,
      ).show();
    }
    else {
      ctrlDomain.toFavPoint(latitud, longitud);
    }
  }

  void deleteAccount(BuildContext context) {
    resetUserValues();
    ctrlDomain.deleteaccount();
    toMainPage(context);
  }

  List<Coordenada> getFavsChargerPoints() {
    return ctrlDomain.getFavChargerPoints();
  }

  List<Coordenada> getFavsBicingPoints() {
    return ctrlDomain.getFavBicingPoints();
  }

  List<String> getNomsFavsChargerPoints() {
    return ctrlDomain.nomsFavCarrega;
  }

  List<String> getNomsFavsBicingPoints() {
    return ctrlDomain.nomsFavBicings;
  }

  void deleteCar(BuildContext context, String idVehicle) {
    ctrlDomain.removeVUser(idVehicle);
    Navigator.pop(context);
    toGaragePage(context);
    //toGaragePage(context);
  }

  void saveCar(BuildContext context,
                String name,
                String brand,
                String modelV,
                String bat,
                String eff,
                List<String> lEndolls
      ) {
    ctrlDomain.addVUser(name, brand, modelV, bat, eff, lEndolls);
    Navigator.pop(context);
    toGaragePage(context);
  }

  void saveEditedCar(BuildContext context,
      String carId,
      String name,
      String brand,
      String modelV,
      String bat,
      String eff,
      List<String> lEndolls) {
    ctrlDomain.editVUser(carId, name, brand, modelV, bat, eff, lEndolls);
    Navigator.pop(context);
    toGaragePage(context);
  }

  Future<List<String>> getAllNamesBicing(List<Coordenada> c) async{
    List<String> l = <String> [];
    for(var i in c){
      String esto = (await ctrlDomain.getInfoBicing(i.latitud, i.longitud))[0];
      l.add(esto);
    }
    return l;
  }

}