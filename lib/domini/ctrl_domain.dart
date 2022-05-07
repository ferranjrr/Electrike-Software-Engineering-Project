import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_project/domini/coordenada.dart';
import 'package:flutter_project/domini/data_graphic.dart';
import 'package:flutter_project/domini/endoll.dart';
import 'package:flutter_project/domini/estacio_carrega.dart';
import 'package:flutter_project/domini/favorit.dart';
import 'package:flutter_project/domini/punt_bicing.dart';
import 'package:flutter_project/domini/services/local_notifications_adpt.dart';
import 'package:flutter_project/domini/services/service_locator.dart';
import 'package:flutter_project/domini/rutes/routes_response.dart';
import 'package:flutter_project/domini/rutes/rutes_amb_carrega.dart';
import 'package:flutter_project/domini/tipus_endoll.dart';
import 'package:flutter_project/domini/tipus_endoll_enum.dart';
import 'package:flutter_project/domini/usuari.dart';
import 'package:flutter_project/domini/vehicle_usuari.dart';
import 'package:flutter_project/domini/vh_electric.dart';
import 'package:flutter_project/interficie/page/profile_page.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter_project/libraries/flutter_google_maps/flutter_google_maps.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class CtrlDomain {
  CtrlDomain._internal();
  static final CtrlDomain _singleton =  CtrlDomain._internal();

  static var urlorg = 'http://electrike.ddns.net:3784/';
  //DATA COORD SYSTEM
  List<Coordenada> coordBicings = <Coordenada>[];
  List<Coordenada> coordPuntsCarrega = <Coordenada>[];
  List<Coordenada> coordBarcelona = <Coordenada>[];
  List<Coordenada> coordCatalunya = <Coordenada>[];
  List<Coordenada> coordCarregadorsPropers = <Coordenada>[];
  Map<String,List<List<double> > > dadesChargerselected = {};

  //DATA INFO SYSTEM
  List<VhElectric> vhElectrics = <VhElectric>[];
  List<EstacioCarrega> puntscarrega= <EstacioCarrega>[];
  List<PuntBicing> puntsBicing= <PuntBicing>[];
  Set<Endoll> endolls = <Endoll>{};
  List<TipusEndoll> typesendolls = <TipusEndoll>[];

  //DATA USER
  Usuari usuari = Usuari();
  VehicleUsuari vhselected = VehicleUsuari.buit();
  late double bateriaInicial; //Bateria inicial del vhUsuari, no cal guardar a la clase VhUsuari
  List<VehicleUsuari> vehiclesUsuari = <VehicleUsuari>[];
  List<Favorit> puntsFavCarrega = <Favorit>[];
  List<Favorit> puntsFavBicing = <Favorit>[];
  List<String> nomsFavBicings = <String>[];
  List<String> nomsFavCarrega = <String>[];
  factory CtrlDomain() {
    return _singleton;
  }

  //SYSTEM
  Future<void> initializeSystem() async {
    usuari.usuarinull();
    initializeTypes();
    await getAllCars();
    await getChargersCoord('cat');
    await getChargersCoord('bcn');
    await getBicings();
  }
  void initializeTypes(){
    List<TipusEndollEnum> types= TipusEndollEnum.values;
    for(var t in types){
      typesendolls.add(TipusEndoll(t));
    }
  }

  //USER
  bool islogged(){
    if (usuari.name == "")return false;
    return true;
  }
  void setIdiom(String idiom)async{
    if(islogged()) {
      var url = urlorg + 'change_language?email=' + usuari.correu + '&language=' + idiom;
      var response = (await http.post(Uri.parse(url)));
    }
  }
  Future<void> initializeUser(String email, String name, String img)async {
    var url = urlorg +'exist_user?email='+email;
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    bool newuser = true;
    if(resp['items'] == email)newuser = false;
    if(newuser){
      url = urlorg +'insert_user?name='+name+'&email='+email+'&img='+img;
      await http.post(Uri.parse(url));
      usuari.correu = email;
      usuari.name = name;
      usuari.foto = img;
      //setIdiom(ctrlPresentation.idiom);
    }
    else {
      url = urlorg + 'user_info?email=' + email;
      var response = await http.get(Uri.parse(url));
      var resp = jsonDecode(response.body);
      usuari.correu = email;
      usuari.name = resp['items'][0]['Name'];
      usuari.foto = resp['items'][0]['Img'];
      await login();
    }
    ctrlPresentation.setUserValues(name, email, img);
  }
  //Carrega la informació dels objectes favorits de l'usuari
  Future<void> login() async{
    var url = urlorg +'get_user_fav_chargers?email='+usuari.correu;
    var responseC = (await http.get(Uri.parse(url)));
    var respC = jsonDecode(responseC.body);
    for(var pfc in respC['items']) {
      if(pfc['lat'] != null || pfc['lon'] != null) {
        puntsFavCarrega.add(Favorit(Coordenada(double.parse(pfc['lat']), double.parse(pfc['lon'])), usuari.correu));
      }
    }
    url = urlorg +'get_user_fav_bicings?email='+usuari.correu;
    var responseB = (await http.get(Uri.parse(url)));
    var respB = jsonDecode(responseB.body);
    for(var pfb in respB['items']){
      if(pfb['lat'] != null || pfb['lon'] != null){
        puntsFavBicing.add(Favorit(Coordenada(double.parse(pfb['lat']),double.parse(pfb['lon'])), usuari.correu));
      }
    }
    var urlc = urlorg +'get_cars_user?email='+usuari.correu;
    var responseCars = (await http.get(Uri.parse(urlc)));
    var respCars = jsonDecode(responseCars.body);
    for(var favcar in respCars['items']){
      List<String> endolls = <String>[];
      if(favcar['Chargers'][0] != '0'){
        endolls.add('Schuko');
        typesendolls[0].cars.add(favcar['Id'].toString());
      }
      if(favcar['Chargers'][1] != '0'){
        endolls.add('Mennekes');
        typesendolls[1].cars.add(favcar['Id'].toString());
      }
      if(favcar['Chargers'][2] != '0'){
        endolls.add('Chademo');
        typesendolls[2].cars.add(favcar['Id'].toString());
      }
      if(favcar['Chargers'][3] != '0'){
        endolls.add('CCSCombo2');
        typesendolls[3].cars.add(favcar['Id'].toString());
      }
    vehiclesUsuari.add(VehicleUsuari(favcar['Id'],favcar['Name'], favcar['Brand'],favcar['Vehicle'],double.parse(favcar['Battery']),double.parse(favcar['Efficiency']), endolls));
    }
    getNomsFavBicing();
    getNomsFavChargers();
    idiomfromLogin();
  }
  //Elimina el continguts dels llistats referents als usuaris per quan fa logout
  void resetUserSystem(){
    vehiclesUsuari = <VehicleUsuari>[];
    puntsFavCarrega = <Favorit>[];
    puntsFavBicing = <Favorit>[];
    vhselected = VehicleUsuari.buit();
    for(var t in typesendolls) {
      t.cars=<String>{};
    }
    usuari.usuarinull();
    //resentation.resetUserValues();
  }
  //Elimina l'usuari de la base de dades i del domini
  void deleteaccount()async{
    var url = urlorg +'delete_user?email='+usuari.correu;
    await http.post(Uri.parse(url));
    resetUserSystem();
  }

  //USER CARS
  void addVUser(String name, String brand, String modelV, String bat, String eff,List<String> lEndolls){

    List<String> endolls = <String>[];
    String schuko = "0";
    String mennekes = "0";
    String chademo ="0";
    String ccscombo2= "0";
    for(var num in lEndolls){
      if(typesendolls[0].tipus.name == num){
        schuko = "1";
        endolls.add('Schuko');
        typesendolls[0].cars.add((vehiclesUsuari.length+1).toString());
      }
      else if(typesendolls[1].tipus.name == num){
        mennekes = "1";
        endolls.add('Mennekes');
        typesendolls[1].cars.add((vehiclesUsuari.length+1).toString());
      }
      else if(typesendolls[2].tipus.name == num){
        chademo = "1";
        endolls.add('Chademo');
        typesendolls[2].cars.add((vehiclesUsuari.length+1).toString());
      }
      else if(typesendolls[3].tipus.name == num){
        ccscombo2 = "1";
        endolls.add('CCSCombo2');
        typesendolls[3].cars.add((vehiclesUsuari.length+1).toString());
      }
    }
    vehiclesUsuari.add(VehicleUsuari(vehiclesUsuari.length+1,name, brand,modelV, double.parse(bat), double.parse(eff), endolls));
    var url = urlorg +'insert_car_user?email='+usuari.correu+'&name='+name+'&brand='+brand+'&vehicle='+modelV+'&battery='+bat+'&efficiency='+eff+'&chargers='+schuko+mennekes+chademo+ccscombo2;
    http.post(Uri.parse(url));
  }
  void editVUser(String idV, String name, String brand, String modelV, String bat, String eff,List<String> lEndolls){
    removeVUser(idV);
    addVUser(name, brand, modelV, bat, eff, lEndolls);

  }
  void removeVUser(String idVehicle){
    int idV = int.parse(idVehicle);
    late VehicleUsuari vdelete;
    for(var vhu in vehiclesUsuari){
      if(vhu.id == idV ){
        vdelete = vhu;
      }
      else if(vhu.id >= idV){
        vhu.id--;
      }
    }
    for(var type in typesendolls){
      type.cars.remove(idVehicle);
      for(var c in type.cars){
        var aux = int.parse(c);
        if(aux > idV) {
          aux = aux - 1;
          c = aux.toString();
        }
      }
    }
    vehiclesUsuari.remove(vdelete);
    var url = urlorg +'remove_car_user?email='+usuari.correu+'&vehicle_id='+idVehicle;
    http.post(Uri.parse(url));
  }
  List<List<String>> infoAllVUser(){
    List<List<String>> datacars = <List<String>>[];
    for(var vhU in vehiclesUsuari){
      List<String> ucar = getInfoUserCar(vhU.id);
      datacars.add(ucar);
    }
    return datacars;
  }

  void selectVehicleUsuari(int idV) {
    for(var vhu in vehiclesUsuari) {
      if (vhu.id == idV) {
        vhselected = vhu;
        return;
      }
    }
  }


  //Si nadie le ha asignado un vehiculo al usuario, currentVehicleUsuari devoldera un vehicle Buit!
  VehicleUsuari currentVehicleUsuari() {
    return vhselected;
  }

  void makeRoute(Location location, String actualLocation, GlobalKey<GoogleMapStateBase> key, String destination) {
    location.getLocation().then((value) {
      String origin = value.latitude.toString() + "," +
          value.longitude.toString();
      if (actualLocation != "Your location") origin = actualLocation;
      GoogleMap.of(key)?.addDirection(
          origin,
          destination,
          startLabel: '1',
          startInfo: 'Origin',
          endIcon: 'assets/images/rolls_royce.png',
          endInfo: 'Destination'
      );
    });
  }

  bool isAFavPoint(double latitud, double longitud) {
    bool trobat = false;
    for(var favc in puntsFavCarrega){
      if(favc.coord.latitud == latitud && favc.coord.longitud == longitud){
        trobat = true;
      }
    }
    if(trobat == false){
      for(var favb in puntsFavBicing){
        if(favb.coord.latitud == latitud && favb.coord.longitud == longitud)trobat = true;
      }
    }
    return trobat;
  }
  void toFavPoint(double latitud, double longitud) {
    bool trobat = false;
    for(var c in coordPuntsCarrega){
      if(c.latitud == latitud && c.longitud == longitud){
        trobat = true;
        gestioFavChargers(latitud, longitud);
      }
    }
    /*
    for(var c in coordCatalunya){
      if(c.latitud == latitud && c.longitud == longitud){
        trobat = true;
        gestioFavChargers(latitud, longitud);
      }
    }
    if(trobat == false){
      for(var c in coordBarcelona){
        if(c.latitud == latitud && c.longitud == longitud){
          trobat = true;
          gestioFavChargers(latitud, longitud);
        }
      }
    }
    else*/if(trobat == false){
      gestioFavBicing(latitud, longitud);
    }
  }

  //USER FAV_CHARGER
  List<Coordenada> getFavChargerPoints() {
    List<Coordenada> listToPassFavs = <Coordenada>[];
    for(var f in puntsFavCarrega){
      listToPassFavs.add(f.coord);
    }
    print("NUMCARREGA"+puntsFavCarrega.toString());
    return listToPassFavs;
  }
  void gestioFavChargers(double lat, double long){
    bool trobat = false;
    for(var fav in puntsFavCarrega){
      if(fav.coord.latitud == lat && fav.coord.longitud == long){
        trobat = true;
      }
    }
    if(trobat){
      deleteFavCharger(lat, long);
    }
    else{
      addFavCharger(lat, long);
    }
  }
  void addFavCharger(double lat, double long)async{
    var url = urlorg +'add_fav_charger?email='+usuari.correu+'&lat='+lat.toString()+'&lon='+long.toString()+'&name='+'pruebanombre';
    await http.post(Uri.parse(url));
    puntsFavCarrega.add(Favorit(Coordenada(lat, long),usuari.correu));
    getNomsFavChargers();
  }
  void deleteFavCharger(double lat, double long)async{
    var url = urlorg +'remove_fav_charger?email='+usuari.correu+'&lat='+lat.toString()+'&lon='+long.toString();
    await http.post(Uri.parse(url));
    Favorit fav = Favorit(Coordenada(-1.0,0.0), '');
    for(var pfc in puntsFavCarrega){
      if(pfc.coord.latitud == lat && pfc.coord.longitud == long){
        fav = pfc;
      }
    }

    if(fav.coord.latitud != -1.0)puntsFavCarrega.remove(fav);
    getNomsFavChargers();
  }

  //USER FAV_BICING
  List<Coordenada> getFavBicingPoints()  {
    List<Coordenada> listToPassFavs = <Coordenada>[];
    for(var f in puntsFavBicing){
      listToPassFavs.add(f.coord);
    }
    return listToPassFavs;
  }
  void gestioFavBicing(double lat, double long){
    bool trobat = false;
    for(var fav in puntsFavBicing){
      if(fav.coord.latitud == lat && fav.coord.longitud == long){
        trobat = true;
      }
    }
    if(trobat){
      deleteFavBicing(lat, long);
    }
    else{
      addFavBicing(lat, long);
    }
  }
  Future<void> addFavBicing(double lat, double long)async{
    var url = urlorg + 'add_fav_bicing?email=' + usuari.correu + '&lat=' + lat.toString() + '&lon=' + long.toString()+'&name'+'pruebanombre';
    puntsFavBicing.add(Favorit(Coordenada(lat, long),usuari.correu));
    await http.post(Uri.parse(url));
    getNomsFavBicing();
  }
  void deleteFavBicing(double lat, double long)async{
    var url = urlorg +'remove_fav_bicing?email='+usuari.correu+'&lat='+lat.toString()+'&lon='+long.toString();
    await http.post(Uri.parse(url));
    Favorit fav = Favorit(Coordenada(-1.0,0.0), '');
    for(var pfb in puntsFavBicing){
      if(pfb.coord.latitud == lat && pfb.coord.longitud == long)fav = pfb;
    }
    if(fav.coord.latitud != -1.0)puntsFavBicing.remove(fav);
    getNomsFavBicing();
  }
  Future<List<String>> getNamesFavBicing()async{
    List<String>namesBFav = <String>[];
    for(var pBFav in puntsFavBicing){
      var url = urlorg +'bicing_info?latitud='+pBFav.coord.latitud.toString()+'&longitud='+pBFav.coord.longitud.toString();
      var response = await http.get(Uri.parse(url));
      var resp = jsonDecode(response.body);
      for(var it in resp['items']){
        namesBFav.add("Bicing"+it['name']);
      }
    }
    return namesBFav;
  }

  //CARS
  Future<void> getAllCars() async {
    var url = urlorg +'cars';
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      VhElectric vh = VhElectric.complet(it['_id'], it['Brand'], it['Vehicle'],double.parse(it['Effciency(Wh/Km)']), double.parse(it['Rage(Km)']), double.parse(it['Battery(kWh)']));
      vhElectrics.add(vh);
    }
  }
  Future<List<String>> getAllBrands() async {
    var url = urlorg +'cars_brands';
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    List<String> carBrands=<String>[];
    for(var it in resp['items']){
      carBrands.add(it);
    }
    carBrands.sort();
    return carBrands;
  }
  Future<List<String>> getAllModels(String brand) async {
    var url = urlorg +'cars_models?Brand='+brand;
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    List<String> models = <String>[];
    for(var it in resp['items']){
      models.add(it);
    }
    models.sort();
    return models;
  }
  List<String> getCarModelInfo(String model) {
    List<String> car = <String>[];
    for(var v in vhElectrics){
      if(v.model == model) {
        car.add(v.id);
        car.add(v.marca);
        car.add(v.model);
        car.add(v.capacitatBateria.toString());
        car.add(v.consum.toString());
        car.add(v.potencia.toString());
        break;
      }
    }
    return car;
  }
  List<String> getInfoUserCar(int id){
    List<String> car = <String>[];
    for(var v in vehiclesUsuari){
      if(v.id == id){
        car.add(id.toString());
        car.add(v.name);
        car.add(v.brand);
        car.add(v.model);
        car.add(v.battery.toString());
        car.add(v.efficiency.toString());
        for(var endoll in v.endolls) {
          if ('Schuko' == endoll) {
            car.add('Schuko');
          }
          else if ('Mennekes' == endoll) {
            car.add('Mennekes');
          }
          else if ('Chademo' == endoll) {
            car.add('Chademo');
          }
          else if ('CCSCombo2' == endoll) {
            car.add('CCSCombo2');
          }
        }
      }
    }
    return car;
  }

  //CHARGERS
  //Carrega des de la base de dades, tota la informació dels carregadors de cat o bcn
  Future<void> getChargers(String where) async {
    var url = urlorg +'chargers_'+where;
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      Set<String>endollsPunt = <String>{};
      for(var en in it['Sockets']){
        endollsPunt.add(en['Connector_id'].toString());
        Endoll endoll = Endoll(en['Connector_id'].toString(), it['_id'], en['State']);
        var list = en['Connector_types'].toString().split(',');
        for(var num in list){
          if(num == "1" || num == "2" || num == "3" || num== "4"){
            int n = int.parse(num);
            n = n-1;
            typesendolls[n].endolls.add(Coordenada(it["Station_lat"],it["Station_lng"]));
            endoll.tipus.add(num);
          }
        }
        endolls.add(endoll);
      }
      if(it['Station_name']== null)it['Station_name']="Unknown";
      if(it['Station_address']== null)it['Station_address']="Unknown";
      coordPuntsCarrega.add(Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));
      EstacioCarrega estCarrega = EstacioCarrega.ambendolls(it['_id'], it['Station_name'], it['Station_address'], it['Station_municipi'],endollsPunt, Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));
      puntscarrega.add(estCarrega);
    }
  }
  //Carrega des de la base de dades, tota la informació d'un carregador de cat o bcn i la guarda al sistema
  Future<void> getInfoChargerCoord(Coordenada coord) async {
    var url = urlorg +'charger_info_cat?longitud='+ coord.longitud.toString() +'&latitud='+coord.latitud.toString();
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      Set<String>endollsPunt = <String>{};
      for(var en in it['Sockets']){
        endollsPunt.add(en['Connector_id'].toString());
        Endoll endoll = Endoll(en['Connector_id'].toString(), it['_id'], en['State']);
        var list = en['Connector_types'].toString().split(',');
        for(var num in list){
          typesendolls[int.parse(num)].endolls.add(it['_id']);
          endoll.tipus.add(num);
        }
        endolls.add(endoll);
      }
      if(it['Station_name']== null)it['Station_name']="Unknown";
      if(it['Station_address']== null)it['Station_address']="Unknown";
      coordPuntsCarrega.add(Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));
      EstacioCarrega estCarrega = EstacioCarrega.ambendolls(it['_id'], it['Station_name'], it['Station_address'],it['Station_municipi'] ,endollsPunt, Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));
      puntscarrega.add(estCarrega);
    }
  }
  //Inútil de moment
  Future<void> getEndollInfo(Coordenada coord) async {
    var url = urlorg +'plug_info?longitud'+ coord.longitud.toString() +'&latitud'+coord.longitud.toString();
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      it;
    }
  }
  //Carrega des de la base de dades, tota la informació d'un carregador de cat o bcn la guarda en una llista que retorna
  Future<List<String>> getInfoCharger2(double lat, double long) async{
    List<String> infoC =<String>[];
    var url = urlorg +'charger_information_cat?longitud='+ long.toString() +'&latitud='+lat.toString();
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      if(it['Station_name']== null)it['Station_name']="Unknown";
      if(it['Station_address']== null)it['Station_address']="Unknown";
      infoC.add(it["_id"]);
      infoC.add(it["Station_name"]);
      infoC.add(it["Station_address"]);
      infoC.add(it["Station_municipi"]);
      infoC.add(it['Sockets'].length.toString());
      List<int> endollsinfo = List.filled(16, 0);
      bool cat = false;
      for(var en in it['Sockets']){
        var l = en['Connector_types'].split(',');
        for(var type in l) {
          var num = int.parse(type)-1;
          switch(en['State']) {
            case 0:{endollsinfo[num*4+0]++;}break;
            case 1: {endollsinfo[num*4+3]++;} break;
            case 4: {endollsinfo[num*4+3]++;} break;
            case 5: {endollsinfo[num*4+3]++;} break;//AÑADIDO
            case 6:{endollsinfo[num*4+1]++; cat = true;} break;
            default:{endollsinfo[num*4+2]++;} break;
          }
        }
      }
      for(int i = 0; i < endollsinfo .length; ++i){
        infoC.add(endollsinfo [i].toString());
      }
      bool isfav = false;
      for(var fav in puntsFavCarrega){
        if(lat == fav.coord.latitud && fav.coord.longitud== long) isfav=true;
      }
      infoC.add(isfav.toString());
      infoC.add(cat.toString());
    }
    return infoC;
  }
  //Carrega des de la base de dades, totes les coordenades dels carregadors de cat o bcn
  Future<void> getChargersCoord(String where)async{
    var url = urlorg +'chargers_'+where;
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);

    for(var it in resp['items']){
      if(where == 'bcn') {
        coordBarcelona.add(Coordenada(
            double.parse(it['Station_lat'].toString()),
            double.parse(it['Station_lng'].toString())));
      }
      else{
        coordCatalunya.add(Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));
      }

      coordPuntsCarrega.add(Coordenada(double.parse(it['Station_lat'].toString()),double.parse(it['Station_lng'].toString())));

      for(var en in it['Sockets']){
        var list = en['Connector_types'].toString().split(',');
        for(var num in list){
          if(num == "1" || num == "2" || num == "3" || num== "4"){
            int n = int.parse(num);
            n = n-1;
            typesendolls[n].endolls.add(Coordenada(it["Station_lat"],it["Station_lng"]));
          }
        }
      }
    }
  }
  /*List<String> getInfoCharger(double lat, double long){
    List<String> infocharger = <String>[];
    for(var charg in puntscarrega){
      if(charg.coord.latitud == lat && charg.coord.longitud == long){
        infocharger.add(charg.id);
        infocharger.add(charg.nom);
        infocharger.add(charg.direccio);
        infocharger.add(charg.ciutat);
        infocharger.add(charg.endolls.length.toString());
        List<int> data = getNumDataEndoll(charg);
        for(int i = 0; i < data.length; ++i){
          infocharger.add(data[i].toString());
        }
        bool isfav = false;
        for(var fav in puntsFavCarrega){
          if(lat == fav.coord.latitud && fav.coord.longitud== long) isfav=true;
        }
        infocharger.add(isfav.toString());
      }
    }
    return infocharger;
  }*/
  List<int> getNumDataEndoll(EstacioCarrega charg){
    List<int> endollsinfo = List.filled(16, 0);
    for(var end in charg.endolls){
      for(var endoll in endolls){
        if(end == endoll.id && endoll.idPuntC == charg.id){
          for(int i = 0; i<endoll.tipus.length;i++) {
            int num = int.parse(endoll.tipus.elementAt(i));
            num = num-1;
            switch(endoll.ocupat) {
              case 0:{endollsinfo[num*4+0]++;}break;
              case 1: {endollsinfo[num*4+3]++;} break;
              case 4: {endollsinfo[num*4+3]++;} break;
              case 5: {endollsinfo[num*4+3]++;} break;//AÑADIDO
              case 6:{endollsinfo[num*4+1]++; }break;
              default:{endollsinfo[num*4+2]++;} break;
            }
          }
        }
      }
    }
    return endollsinfo;
  }

  //BICING
  Future<void> getBicings()async{
    var url = urlorg +'bicings';
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      coordBicings.add(Coordenada(double.parse(it['lat'].toString()),double.parse(it['lon'].toString())));
    }
  }
  Future<List<String>> getInfoBicing(double lat, double long) async{
    List<String> lpb = <String>[];
    var id = 0;
    String nom = '';
    String direccio = '';
    var numB = 0;
    var numBm = 0;
    var numBe = 0;
    var numDock = 0;
    var url = urlorg +'bicing_info?latitud='+lat.toString()+'&longitud='+long.toString();
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      id = it["station_id"];
      nom = "Bicing"+it["name"];
      direccio = it["address"];
    }
    url = urlorg +'bicing_status?id='+id.toString();
    response = (await http.get(Uri.parse(url)));
    resp = jsonDecode(response.body);
    for(var it in resp['items']){
      numBm = it['num_bikes_available_types']['mechanical'];
      numBe = it['num_bikes_available_types']['ebike'];
      numDock = it['num_docks_available'];
    }
    lpb.add(nom);
    lpb.add(direccio);
    lpb.add(numB.toString());
    lpb.add(numBm.toString());
    lpb.add(numBe.toString());
    lpb.add(numDock.toString());
    bool isfav = false;
    for(var fav in puntsFavBicing){
      if(lat == fav.coord.latitud && fav.coord.longitud== long) isfav=true;
    }
    lpb.add(isfav.toString());
    return lpb;
  }

  void getCARSUSER()async{
    var urlc = 'http://electrike.ddns.net:3784/get_cars_user?email=alvaro.rodriguez.rubio@estudiantat.upc.edu';
    var responseCars = (await http.get(Uri.parse(urlc)));
    var respCars = jsonDecode(responseCars.body);
    List<VehicleUsuari> vehiclesUsuari = <VehicleUsuari>[];
    for(var favcar in respCars['items']){
    vehiclesUsuari.add(VehicleUsuari(favcar['Id'],favcar['Name'], favcar['Brand'],favcar['Vehicle'],favcar['Battery'],favcar['Efficiency'], favcar['Chargers']));
    }
  }

  void getNomsFavChargers() async{
    nomsFavCarrega = <String>[];
    for(var c in puntsFavCarrega){
      var url = urlorg+'charger_information_cat?longitud='+ c.coord.longitud.toString() +'&latitud='+c.coord.latitud.toString();
      var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    for(var it in resp['items']){
      nomsFavCarrega.add(it['Station_name']);
    }
    }
  }
  void getNomsFavBicing() async{
    nomsFavBicings = <String>[];
    for(var c in puntsFavBicing){
      var url = urlorg+'bicing_info?longitud='+ c.coord.longitud.toString() +'&latitud='+c.coord.latitud.toString();
      var response = (await http.get(Uri.parse(url)));
      var resp = jsonDecode(response.body);
      for(var it in resp['items']){
        nomsFavBicings.add('Bicing'+it['name']);
      }
    }
  }

  Future<bool> isBrand(String brand) async {
    List<String> brands = await getAllBrands();
    for (String current in brands) {
      if (current.toLowerCase() == brand.toLowerCase()) {
        return true;
      }
    }
    return false;
  }
  
  Future<void> getNearChargers(double lat, double lon, double radius) async{
    var urlc = urlorg+'near_chargers?lat='+ lat.toString() + '&lon=' + lon.toString() + '&dist=' + radius.toString();
    var responseCars = (await http.get(Uri.parse(urlc)));
    var respCars = jsonDecode(responseCars.body);
    for(var info in respCars['items']){
      coordCarregadorsPropers.add(Coordenada(info['Station_lat'],info['Station_lng']));
    }
  }
  
  void idiomfromLogin() async {
    var url = urlorg + 'user_language?email=' + usuari.correu;
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    usuari.idiom = resp['items'];
  }

  List<Coordenada> getCompChargers() {
    List<String> endollsVh = vhselected.endolls; // nombres de enchufes del VH
    List<Coordenada> carregadorsCompatibles = <Coordenada>[];
    for(var endoll in typesendolls) {
      for (var nom in endollsVh) {
        if (endoll.tipus.name == nom) {
          carregadorsCompatibles.addAll(endoll.endolls);
        }
      }
    }
    return carregadorsCompatibles;
  }
    
  // Si el punto de carga no es de Barcelona, se mostrará unknown en el status.
  void showInstantNotification(double lat, double long) {
    serviceLocator<LocalNotificationAdpt>().showInstantNotification(lat, long);
  }

  /*
  day between 1 (Monday) to 7 (Sunday)
    Si el punto de carga no es de Barcelona, se mostrará unknown en el status.
   */
  void addSheduledNotificationFavoriteChargePoint(double lat, double long, int day, int iniHour, int iniMinute/*, int endHour*//*, int endMinute*/) {

    var dayOfTheWeek = DateTime(DateTime.now().year, DateTime.now().month, day, iniHour, iniMinute);
    var firstNotification = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour, iniMinute);
    int daysToAdd;

    //si el dia donat és diferent del dia d'avui
    if (day < DateTime.now().weekday) {
      daysToAdd = 7 - (DateTime.now().weekday - day);
      firstNotification.add(Duration(days: daysToAdd));
    }
    else if (day > DateTime.now().weekday) {
      daysToAdd = day - DateTime.now().weekday;
      firstNotification.add(Duration(days: daysToAdd));
    }
    /*else if (DateTime.now().hour < iniHour){

    }
    //mateix dia
    else if (DateTime.now().hour >= iniHour) {
      //if (DateTime.now().hour < endHour) { //en aquest cas no apareixerà cap notificació fins la setmana següent.
        //firstNotification = DateTime.now();
    //  }
     // else {
        firstNotification.add(const Duration(days: 7));
      //}
    }
    /*
    else if (DateTime.now().minute <= minute) {

    }
    else if (DateTime.now().minute > minute) {
      firstNotification.add(const Duration(days: 7));
    }
    */

    firstNotification = DateTime.utc(firstNotification.year, firstNotification.month, firstNotification.day, iniHour, iniMinute);
    final pacificTimeZone = tz.getLocation('Europe/Paris');
    //arreglar lo de les zones horaries.
    serviceLocator<LocalNotificationAdpt>().scheduleNotifications(firstNotification, lat, long);
    */

    //print(firstNotification);

    firstNotification = DateTime(firstNotification.year, firstNotification.month, firstNotification.day, iniHour, iniMinute);
    firstNotification = firstNotification.toUtc();
    //print(firstNotification);

    serviceLocator<LocalNotificationAdpt>().scheduleNotifications(firstNotification, lat, long);




    //cancel notifications:


    //------


  }

  Future<RoutesResponse> findSuitableRoute(GeoCoord origen, GeoCoord destino, double bateriaPerc) async {
    RutesAmbCarrega rutesAmbCarrega = RutesAmbCarrega();
    RoutesResponse routesResponse = await rutesAmbCarrega.algorismeMillorRuta(origen, destino, bateriaPerc, vhselected.efficiency);
    return routesResponse;
  }

  Future<void> getOcupationCharger(double lat, double lon) async {
    var url = urlorg + 'get_ocupation?lat='+ lat.toString() +'&lon='+ lon.toString();
    var response = (await http.get(Uri.parse(url)));
    var resp = jsonDecode(response.body);
    String day = "";
    List<List<double>> empty = <List<double>>[];
    empty.add(<double>[]);
    empty.add(<double>[]);
    dadesChargerselected = {};
    List<String> nameday = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
    for(String day in nameday) {
      List<List<double>> empty = <List<double>>[];
      empty.add(<double>[]);
      empty.add(<double>[]);
      dadesChargerselected[day] = empty;
    }
    for(var dada in resp['items']){
      dadesChargerselected[dada['WeekDay']]![0].add(double.parse(dada["Hour"].toString()));
      dadesChargerselected[dada['WeekDay']]![1].add(double.parse((double.parse(dada["Ocupation"].toString())/double.parse(dada["Capacity"].toString())*100.0).toStringAsFixed(2)));
    }
    print(dadesChargerselected);
  }

  List<DataGraphic> getInfoGraphic(String day){
    List<DataGraphic> data = <DataGraphic>[];
    if(dadesChargerselected[day]!.isNotEmpty){
      var temp = dadesChargerselected[day]![0];
      var temp2 = dadesChargerselected[day]![1];
      for(int i = 0; i < temp.length; ++i){
        data.add(DataGraphic(temp[i], temp2[i]));
      }
    }
    return data;
  }
}
