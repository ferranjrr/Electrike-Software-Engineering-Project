import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  var googleMapApiKey = "***REMOVED***";

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();



}