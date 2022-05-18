


import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageName => 'English';

  @override
  String get map => 'Map';

  @override
  String get garage => 'Garage';

  @override
  String get favourites => 'Favourites';

  @override
  String get achievements => 'Achievements';

  @override
  String get information => 'Information';

  @override
  String get contactUs => 'Contact us';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'System language';

  @override
  String get allFavourites => 'All favourites';

  @override
  String get chargers => 'Chargers';

  @override
  String get bicing => 'Bicing';

  @override
  String get newCar => 'New vehicle';

  @override
  String get efficiency => 'Efficiency';

  @override
  String get carBrand => 'Brand';

  @override
  String get carNameHint => 'The Amazing Red Car';

  @override
  String get carNameLabel => 'Name of the vehicle';

  @override
  String get carModelLabel => 'Model';

  @override
  String get carBatteryLabel => 'Battery(kWh)';

  @override
  String get carEfficiency => 'Efficiency(Wh/Km)';

  @override
  String get carBrandLabel => 'Please select a brand';

  @override
  String get maxCharMssg => 'You cannot have more than 15 characters';

  @override
  String get chargerTypeLabel => 'Select the charger that the car can use (also take into consideration the adapters, in case of having any)';

  @override
  String get add => 'Add';

  @override
  String get login => 'Log-in';

  @override
  String get notLogged => 'You aren\'t logged yet';

  @override
  String get clickToLogin => 'Click to log-in';

  @override
  String get alertSureDeleteCarTitle => 'Are you sure you want to delete this vehicle?';

  @override
  String get alertSureDeleteCarContent => 'Deleting this car is permanent and will remove all data saved associated to this vehicle.\nAre you sure you want to continue?\n';

  @override
  String get msgSelectChargers => 'At least select one type of charger';

  @override
  String get msgIntroNum => 'Introduce a number';

  @override
  String get msgAddFav => 'Add point to favourites';

  @override
  String infoCar(Object selectedNameCar, Object selectedBrandCar, Object selectedModelCar, Object selectedBatteryCar, Object selectedEffciencyCar, Object selectedPlugs) {
    return 'The vehicle\'s name is $selectedNameCar\\n \n  It\'s Brand $selectedBrandCar\\n\n  It\'s model $selectedModelCar\\n\n   Battery $selectedBatteryCar kWh\\n\n   Effciency $selectedEffciencyCar Wh/Km\\n\n The vehicle uses $selectedPlugs\\n\'\'\'),';
  }

  @override
  String get textWithPlaceholder => 'Welcome {name}';

  @override
  String textWithPlaceholders(Object firstName, Object lastName) {
    return 'My name is $lastName, $firstName $lastName';
  }

  @override
  String get infoDialogNotLog => 'You aren\'t logged';

  @override
  String get save => 'Save changes';

  @override
  String get vehicles => 'Vehicles';

  @override
  String get trophies => 'Trophies';

  @override
  String get savedco2 => 'Saved CO2';

  @override
  String get day1 => 'Monday';

  @override
  String get day2 => 'Tuesday';

  @override
  String get day3 => 'Wednesday';

  @override
  String get day4 => 'Thursday';

  @override
  String get day5 => 'Friday';

  @override
  String get day6 => 'Saturday';

  @override
  String get day7 => 'Sunday';

  @override
  String get notificationSettings => 'Notification settings';

  @override
  String get receiveNoti => 'Frequency';

  @override
  String get time => 'Hour';

  @override
  String get addNoti => 'Add notification';

  @override
  String notificationInfoMsg(Object days, Object hora, Object min) {
    return 'A notificacion will be sent in $days at $hora:$min';
  }

  @override
  String get addFavPoints => 'Add point to favourites';

  @override
  String get explNoFav => 'Log-in to see your favourites';

  @override
  String get hideMarkers => 'Hide all';

  @override
  String get showMarkers => 'Show all';

  @override
  String get favouritesMark => 'Favourites';

  @override
  String get selectCar => 'Select a vehicle';

  @override
  String get actualBatMsg => 'Enter the remaining battery';

  @override
  String get selectRouteType => 'Select a route type';

  @override
  String get start => 'Start';
}
