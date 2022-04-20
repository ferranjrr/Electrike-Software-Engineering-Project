// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'es';

  static String m0(howMany) =>
      "${Intl.plural(howMany, one: 'You have 1 notification', other: 'You have ${howMany} notifications')}";

  static String m1(selectedNameCar, selectedBrandCar, selectedModelCar,
          selectedBatteryCar, selectedEffciencyCar, selectedPlugs) =>
      "El nombre del vehículo es ${selectedNameCar}\\n \n  Su marca ${selectedBrandCar}\\n\n  Su modelo ${selectedModelCar}\\n\n   Batería ${selectedBatteryCar} kWh\\n\n   Consumo ${selectedEffciencyCar} Wh/Km\\n\n El vehículo utiliza ${selectedPlugs}\\n\'\'\'),";

  static String m2(name) => "Welcome ${name}";

  static String m3(firstName, lastName) =>
      "My name is ${lastName}, ${firstName} ${lastName}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "achievements": MessageLookupByLibrary.simpleMessage("Logros"),
        "add": MessageLookupByLibrary.simpleMessage("Añadir"),
        "alertSureDeleteCarContent": MessageLookupByLibrary.simpleMessage(
            "La eliminación de este vehículo es permanente y eliminará todos los datos guardados asociados a éste.\n¿Estás seguro de que quieres continuar?"),
        "alertSureDeleteCarTitle": MessageLookupByLibrary.simpleMessage(
            "¿Estás seguro de que quieres eliminar este coche?"),
        "allFavourites":
            MessageLookupByLibrary.simpleMessage("Todos mis favoritos"),
        "bicing": MessageLookupByLibrary.simpleMessage("Bicing"),
        "carBatteryLabel": MessageLookupByLibrary.simpleMessage("Batería(kWh)"),
        "carBrand": MessageLookupByLibrary.simpleMessage("Marca"),
        "carBrandLabel": MessageLookupByLibrary.simpleMessage(
            "Por favor, slecciona una marca"),
        "carEfficiency": MessageLookupByLibrary.simpleMessage("Consumo(Wh/Km)"),
        "carModelLabel": MessageLookupByLibrary.simpleMessage("Modelo"),
        "carNameHint":
            MessageLookupByLibrary.simpleMessage("El increíble buga rojo"),
        "carNameLabel":
            MessageLookupByLibrary.simpleMessage("Nombre del vehiculo"),
        "chargerTypeLabel": MessageLookupByLibrary.simpleMessage(
            "Select the charger that the car can use (also take into consideration the adapters, in case of having any)"),
        "chargers": MessageLookupByLibrary.simpleMessage("Cargadores"),
        "clickToLogin": MessageLookupByLibrary.simpleMessage(
            "Haga clic para iniciar sesión"),
        "contactUs": MessageLookupByLibrary.simpleMessage("Contáctanos"),
        "efficiency": MessageLookupByLibrary.simpleMessage("Consumo"),
        "favourites": MessageLookupByLibrary.simpleMessage("Favoritos"),
        "garage": MessageLookupByLibrary.simpleMessage("Garage"),
        "howManyCars": m0,
        "infoCar": m1,
        "information": MessageLookupByLibrary.simpleMessage("Información"),
        "language": MessageLookupByLibrary.simpleMessage("Idioma"),
        "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
        "logout": MessageLookupByLibrary.simpleMessage("Cerrar sesión"),
        "map": MessageLookupByLibrary.simpleMessage("Mapa"),
        "maxCharMssg": MessageLookupByLibrary.simpleMessage(
            "El máximo número de caácteres es 15"),
        "msgIntroNum":
            MessageLookupByLibrary.simpleMessage("Introduce un número"),
        "msgSelectChargers": MessageLookupByLibrary.simpleMessage(
            "Selecciona al menos un cargador"),
        "newCar": MessageLookupByLibrary.simpleMessage("Nuevo vehículo"),
        "power": MessageLookupByLibrary.simpleMessage("Poténcia"),
        "systemLanguage":
            MessageLookupByLibrary.simpleMessage("Lenguaje del sistema"),
        "textWithPlaceholder": m2,
        "textWithPlaceholders": m3,
        "toAddCarLogin": MessageLookupByLibrary.simpleMessage(
            "¡Para agregar un vehículo debes estar registrado!")
      };
}
