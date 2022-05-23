
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es')
  ];

  /// No description provided for @languageName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageName;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @favourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favourites;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get systemLanguage;

  /// No description provided for @allFavourites.
  ///
  /// In en, this message translates to:
  /// **'All favourites'**
  String get allFavourites;

  /// No description provided for @chargers.
  ///
  /// In en, this message translates to:
  /// **'Chargers'**
  String get chargers;

  /// No description provided for @bicing.
  ///
  /// In en, this message translates to:
  /// **'Bicing'**
  String get bicing;

  /// No description provided for @newCar.
  ///
  /// In en, this message translates to:
  /// **'New vehicle'**
  String get newCar;

  /// No description provided for @efficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency'**
  String get efficiency;

  /// No description provided for @carBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get carBrand;

  /// No description provided for @carNameHint.
  ///
  /// In en, this message translates to:
  /// **'The Amazing Red Car'**
  String get carNameHint;

  /// No description provided for @carNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name of the vehicle'**
  String get carNameLabel;

  /// No description provided for @carModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get carModelLabel;

  /// No description provided for @carBatteryLabel.
  ///
  /// In en, this message translates to:
  /// **'Battery(kWh)'**
  String get carBatteryLabel;

  /// No description provided for @carEfficiency.
  ///
  /// In en, this message translates to:
  /// **'Efficiency(Wh/Km)'**
  String get carEfficiency;

  /// No description provided for @carBrandLabel.
  ///
  /// In en, this message translates to:
  /// **'Please select a brand'**
  String get carBrandLabel;

  /// No description provided for @maxCharMssg.
  ///
  /// In en, this message translates to:
  /// **'You cannot have more than 15 characters'**
  String get maxCharMssg;

  /// No description provided for @chargerTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select the charger that the car can use (also take into consideration the adapters, in case of having any)'**
  String get chargerTypeLabel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log-in'**
  String get login;

  /// No description provided for @notLogged.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t logged yet'**
  String get notLogged;

  /// No description provided for @clickToLogin.
  ///
  /// In en, this message translates to:
  /// **'Click to log-in'**
  String get clickToLogin;

  /// No description provided for @alertSureDeleteCarTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this vehicle?'**
  String get alertSureDeleteCarTitle;

  /// No description provided for @alertSureDeleteCarContent.
  ///
  /// In en, this message translates to:
  /// **'Deleting this car is permanent and will remove all data saved associated to this vehicle.\nAre you sure you want to continue?\n'**
  String get alertSureDeleteCarContent;

  /// No description provided for @msgSelectChargers.
  ///
  /// In en, this message translates to:
  /// **'At least select one type of charger'**
  String get msgSelectChargers;

  /// No description provided for @msgIntroNum.
  ///
  /// In en, this message translates to:
  /// **'Introduce a number'**
  String get msgIntroNum;

  /// No description provided for @msgAddFav.
  ///
  /// In en, this message translates to:
  /// **'Add point to favourites'**
  String get msgAddFav;

  /// No description provided for @lunes.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get lunes;

  /// No description provided for @martes.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get martes;

  /// No description provided for @miercoles.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get miercoles;

  /// No description provided for @jueves.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get jueves;

  /// No description provided for @viernes.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get viernes;

  /// No description provided for @sabado.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sabado;

  /// No description provided for @domingo.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get domingo;

  /// No description provided for @infoCar.
  ///
  /// In en, this message translates to:
  /// **'The vehicle\'s name is {selectedNameCar}\\n \n  It\'s Brand {selectedBrandCar}\\n\n  It\'s model {selectedModelCar}\\n\n   Battery {selectedBatteryCar} kWh\\n\n   Effciency {selectedEffciencyCar} Wh/Km\\n\n The vehicle uses {selectedPlugs}\\n\'\'\'),'**
  String infoCar(Object selectedNameCar, Object selectedBrandCar, Object selectedModelCar, Object selectedBatteryCar, Object selectedEffciencyCar, Object selectedPlugs);

  /// No description provided for @textWithPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Welcome {name}'**
  String get textWithPlaceholder;

  /// No description provided for @textWithPlaceholders.
  ///
  /// In en, this message translates to:
  /// **'My name is {lastName}, {firstName} {lastName}'**
  String textWithPlaceholders(Object firstName, Object lastName);

  /// No description provided for @infoDialogNotLog.
  ///
  /// In en, this message translates to:
  /// **'You aren\'t logged'**
  String get infoDialogNotLog;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get save;

  /// No description provided for @vehicles.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicles;

  /// No description provided for @trophies.
  ///
  /// In en, this message translates to:
  /// **'Trophies'**
  String get trophies;

  /// No description provided for @savedco2.
  ///
  /// In en, this message translates to:
  /// **'Saved CO2'**
  String get savedco2;

  /// No description provided for @kilometerstraveled.
  ///
  /// In en, this message translates to:
  /// **'Kilometerstraveled'**
  String get kilometerstraveled;

  /// No description provided for @routestaken.
  ///
  /// In en, this message translates to:
  /// **'Routes taken'**
  String get routestaken;

  /// No description provided for @deleteaccountquestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account?'**
  String get deleteaccountquestion;

  /// No description provided for @deleteaccountdesc.
  ///
  /// In en, this message translates to:
  /// **'Deleting the account is permanent and will remove all content including cars, favourites points and profile settings.'**
  String get deleteaccountdesc;

  /// No description provided for @day1.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get day1;

  /// No description provided for @day2.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get day2;

  /// No description provided for @day3.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get day3;

  /// No description provided for @day4.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get day4;

  /// No description provided for @day5.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get day5;

  /// No description provided for @day6.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get day6;

  /// No description provided for @day7.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get day7;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get notificationSettings;

  /// No description provided for @receiveNoti.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get receiveNoti;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get time;

  /// No description provided for @addNoti.
  ///
  /// In en, this message translates to:
  /// **'Add notification'**
  String get addNoti;

  /// No description provided for @notificationInfoMsg.
  ///
  /// In en, this message translates to:
  /// **'A notificacion will be sent in {days} at {hora}:{min}'**
  String notificationInfoMsg(Object days, Object hora, Object min);

  /// No description provided for @addFavPoints.
  ///
  /// In en, this message translates to:
  /// **'Add point to favourites'**
  String get addFavPoints;

  /// No description provided for @explNoFav.
  ///
  /// In en, this message translates to:
  /// **'Log-in to see your favourites'**
  String get explNoFav;

  /// No description provided for @hideMarkers.
  ///
  /// In en, this message translates to:
  /// **'Hide all'**
  String get hideMarkers;

  /// No description provided for @showMarkers.
  ///
  /// In en, this message translates to:
  /// **'Show all'**
  String get showMarkers;

  /// No description provided for @favouritesMark.
  ///
  /// In en, this message translates to:
  /// **'Favourites'**
  String get favouritesMark;

  /// No description provided for @selectCar.
  ///
  /// In en, this message translates to:
  /// **'Select a vehicle'**
  String get selectCar;

  /// No description provided for @actualBatMsg.
  ///
  /// In en, this message translates to:
  /// **'Enter the remaining battery'**
  String get actualBatMsg;

  /// No description provided for @selectRouteType.
  ///
  /// In en, this message translates to:
  /// **'Select a route type'**
  String get selectRouteType;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @chargingStop.
  ///
  /// In en, this message translates to:
  /// **'Charging stop'**
  String get chargingStop;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @occupationChart.
  ///
  /// In en, this message translates to:
  /// **'Occupation Chart'**
  String get occupationChart;

  /// No description provided for @occupationChartlegend.
  ///
  /// In en, this message translates to:
  /// **'Occupation Chart Legend'**
  String get occupationChartlegend;

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get yourLocation;

  /// No description provided for @thispage.
  ///
  /// In en, this message translates to:
  /// **'In this page'**
  String get thispage;

  /// No description provided for @thispagedesc.
  ///
  /// In en, this message translates to:
  /// **'You can see the stats about the concurrency of a charge station from Barcelona during the day.'**
  String get thispagedesc;

  /// No description provided for @clickdropdownbutton.
  ///
  /// In en, this message translates to:
  /// **'Click on dropdown button'**
  String get clickdropdownbutton;

  /// No description provided for @clickdropdownbuttondesc.
  ///
  /// In en, this message translates to:
  /// **'You can change the day and it\'s associated values to the plot by clicking on the dropdown button.'**
  String get clickdropdownbuttondesc;

  /// No description provided for @concurrencypercentage.
  ///
  /// In en, this message translates to:
  /// **'Concurrency percentage'**
  String get concurrencypercentage;

  /// No description provided for @concurrencypercentagedesc.
  ///
  /// In en, this message translates to:
  /// **'On the Y axis of the plot, you can see the concurrency percentage for a specific hour of the day.'**
  String get concurrencypercentagedesc;

  /// No description provided for @concurrencyhours.
  ///
  /// In en, this message translates to:
  /// **'Concurrency hours'**
  String get concurrencyhours;

  /// No description provided for @concurrencyhoursdesc.
  ///
  /// In en, this message translates to:
  /// **'On the X axis of the plot, you can see the hours of a day, where the bars indicating the concurrency are.'**
  String get concurrencyhoursdesc;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errordesc.
  ///
  /// In en, this message translates to:
  /// **'If the plot is empty, it could mean 2 things, nobody utilizes the charger or there\'s an error where you will need to update the page.'**
  String get errordesc;

  /// No description provided for @notLoggedMsg.
  ///
  /// In en, this message translates to:
  /// **'Log-in is required'**
  String get notLoggedMsg;

  /// No description provided for @keyChargers.
  ///
  /// In en, this message translates to:
  /// **'Charging point key'**
  String get keyChargers;

  /// No description provided for @keyBicing.
  ///
  /// In en, this message translates to:
  /// **'Bicing station key'**
  String get keyBicing;

  /// No description provided for @keyFavourites.
  ///
  /// In en, this message translates to:
  /// **'Favourites key'**
  String get keyFavourites;

  /// No description provided for @stationName.
  ///
  /// In en, this message translates to:
  /// **'Station name'**
  String get stationName;

  /// No description provided for @streetName.
  ///
  /// In en, this message translates to:
  /// **'Street name'**
  String get streetName;

  /// No description provided for @availableChargers.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableChargers;

  /// No description provided for @numChargers.
  ///
  /// In en, this message translates to:
  /// **'Number of available chargers'**
  String get numChargers;

  /// No description provided for @unknownState.
  ///
  /// In en, this message translates to:
  /// **'Unknown state'**
  String get unknownState;

  /// No description provided for @numUnknown.
  ///
  /// In en, this message translates to:
  /// **'Number of chargers of unknown state'**
  String get numUnknown;

  /// No description provided for @broken.
  ///
  /// In en, this message translates to:
  /// **'Broken'**
  String get broken;

  /// No description provided for @numBroken.
  ///
  /// In en, this message translates to:
  /// **'Number of broken chargers'**
  String get numBroken;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// No description provided for @numNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Number of not available chargers'**
  String get numNotAvailable;

  /// No description provided for @freePlaces.
  ///
  /// In en, this message translates to:
  /// **'Free places'**
  String get freePlaces;

  /// No description provided for @numFreePlaces.
  ///
  /// In en, this message translates to:
  /// **'Number of free places'**
  String get numFreePlaces;

  /// No description provided for @availablePedal.
  ///
  /// In en, this message translates to:
  /// **'Available pedal bikes'**
  String get availablePedal;

  /// No description provided for @numPedal.
  ///
  /// In en, this message translates to:
  /// **'Number of pedal bikes'**
  String get numPedal;

  /// No description provided for @availableElectric.
  ///
  /// In en, this message translates to:
  /// **'Available electric bicycles'**
  String get availableElectric;

  /// No description provided for @numElectric.
  ///
  /// In en, this message translates to:
  /// **'Number of available electric bicycles'**
  String get numElectric;

  /// No description provided for @clickName.
  ///
  /// In en, this message translates to:
  /// **'Click on the name'**
  String get clickName;

  /// No description provided for @clickNameDescr.
  ///
  /// In en, this message translates to:
  /// **'You can go to the location on the map by selecting the point'**
  String get clickNameDescr;

  /// No description provided for @seeConcurrencyChart.
  ///
  /// In en, this message translates to:
  /// **'See station occupancy percentage'**
  String get seeConcurrencyChart;

  /// No description provided for @chartsDescr.
  ///
  /// In en, this message translates to:
  /// **'Shows the occupation of the station during the day'**
  String get chartsDescr;

  /// No description provided for @disableNoti.
  ///
  /// In en, this message translates to:
  /// **'Disable notifications'**
  String get disableNoti;

  /// No description provided for @disableNotiDescr.
  ///
  /// In en, this message translates to:
  /// **'Disable all notifications (if have any)'**
  String get disableNotiDescr;

  /// No description provided for @enableNoti.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enableNoti;

  /// No description provided for @enableNotiDescr.
  ///
  /// In en, this message translates to:
  /// **'Enable all notifications (if have any) so you can receive the occupancy rate of a charger'**
  String get enableNotiDescr;

  /// No description provided for @notificationSettingsDescr.
  ///
  /// In en, this message translates to:
  /// **'Shows all the notifications created for the point. Here you can add more or delete others.'**
  String get notificationSettingsDescr;

  /// No description provided for @rmvFavs.
  ///
  /// In en, this message translates to:
  /// **'Remove from favourites'**
  String get rmvFavs;

  /// No description provided for @rmvFavsDescr.
  ///
  /// In en, this message translates to:
  /// **'You can remove directly the point from your favourites list.'**
  String get rmvFavsDescr;

  /// No description provided for @filterFavTypes.
  ///
  /// In en, this message translates to:
  /// **'Filter between types'**
  String get filterFavTypes;

  /// No description provided for @filterFavTypesDescr.
  ///
  /// In en, this message translates to:
  /// **'Filter the types of favourite points using the bottom buttons'**
  String get filterFavTypesDescr;

  /// No description provided for @addAlert.
  ///
  /// In en, this message translates to:
  /// **'Add alert'**
  String get addAlert;

  /// No description provided for @addAlertDescr.
  ///
  /// In en, this message translates to:
  /// **'You need to have at least one created alert associated with the point.'**
  String get addAlertDescr;

  /// No description provided for @addalertdesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t got any alert associated with this point. Add at least one to receive notifications from this point.'**
  String get addalertdesc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get next;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @unlocked.
  ///
  /// In en, this message translates to:
  /// **'unlocked'**
  String get unlocked;

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'locked'**
  String get locked;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State: '**
  String get state;

  /// No description provided for @nametrophy.
  ///
  /// In en, this message translates to:
  /// **'Trophy: '**
  String get nametrophy;

  /// No description provided for @trophy0.
  ///
  /// In en, this message translates to:
  /// **'Your first vehicle!'**
  String get trophy0;

  /// No description provided for @trophy1.
  ///
  /// In en, this message translates to:
  /// **'Three is a multitude of vehicles'**
  String get trophy1;

  /// No description provided for @trophy2.
  ///
  /// In en, this message translates to:
  /// **'Your garage is amazing!'**
  String get trophy2;

  /// No description provided for @trophy3.
  ///
  /// In en, this message translates to:
  /// **'Destiny found'**
  String get trophy3;

  /// No description provided for @trophy4.
  ///
  /// In en, this message translates to:
  /// **'Excursionist'**
  String get trophy4;

  /// No description provided for @trophy5.
  ///
  /// In en, this message translates to:
  /// **'Globetrotter'**
  String get trophy5;

  /// No description provided for @trophy6.
  ///
  /// In en, this message translates to:
  /// **'Less CO2'**
  String get trophy6;

  /// No description provided for @trophy7.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to save'**
  String get trophy7;

  /// No description provided for @trophy8.
  ///
  /// In en, this message translates to:
  /// **'Saving the planet'**
  String get trophy8;

  /// No description provided for @trophy9.
  ///
  /// In en, this message translates to:
  /// **'The first kilometers'**
  String get trophy9;

  /// No description provided for @trophy10.
  ///
  /// In en, this message translates to:
  /// **'Reaching 100'**
  String get trophy10;

  /// No description provided for @trophy11.
  ///
  /// In en, this message translates to:
  /// **'The road is your life'**
  String get trophy11;

  /// No description provided for @trophy0desc.
  ///
  /// In en, this message translates to:
  /// **'Add 1 vehicle to the garage'**
  String get trophy0desc;

  /// No description provided for @trophy1desc.
  ///
  /// In en, this message translates to:
  /// **'Add 3 vehicles to the garage'**
  String get trophy1desc;

  /// No description provided for @trophy2desc.
  ///
  /// In en, this message translates to:
  /// **'Add 5 vehicles to the garage'**
  String get trophy2desc;

  /// No description provided for @trophy3desc.
  ///
  /// In en, this message translates to:
  /// **'Do 1 route'**
  String get trophy3desc;

  /// No description provided for @trophy4desc.
  ///
  /// In en, this message translates to:
  /// **'Do 10 routes'**
  String get trophy4desc;

  /// No description provided for @trophy5desc.
  ///
  /// In en, this message translates to:
  /// **'Do 50 routes'**
  String get trophy5desc;

  /// No description provided for @trophy6desc.
  ///
  /// In en, this message translates to:
  /// **'Save 5 kg of CO2, using an electric vehicle'**
  String get trophy6desc;

  /// No description provided for @trophy7desc.
  ///
  /// In en, this message translates to:
  /// **'Save 20 kg of CO2, using an electric vehicle'**
  String get trophy7desc;

  /// No description provided for @trophy8desc.
  ///
  /// In en, this message translates to:
  /// **'Save 50 kg of CO2, using an electric vehicle'**
  String get trophy8desc;

  /// No description provided for @trophy9desc.
  ///
  /// In en, this message translates to:
  /// **'Travel 20 km with electric vehicles'**
  String get trophy9desc;

  /// No description provided for @trophy10desc.
  ///
  /// In en, this message translates to:
  /// **'Travel 100 km with electric vehicles'**
  String get trophy10desc;

  /// No description provided for @trophy11desc.
  ///
  /// In en, this message translates to:
  /// **'Travel 200 km with electric vehicles'**
  String get trophy11desc;

  /// No description provided for @defaulttitle.
  ///
  /// In en, this message translates to:
  /// **'Default title'**
  String get defaulttitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return AppLocalizationsCa();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
