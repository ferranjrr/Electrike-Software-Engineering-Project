import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  var googleMapApiKey = "***REMOVED***";
  static final _googleSignIn = GoogleSignIn();

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();

  Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();


}