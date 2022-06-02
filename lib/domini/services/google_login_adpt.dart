import 'package:flutter_project/domini/ctrl_domain.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  static const _clientIDWeb= "***REMOVED***";
  //static const _clientIDAndroid = "***REMOVED***";

  static final _googleSignInAndroid = GoogleSignIn(scopes: [
    'email',
    'profile',
  ],);
  static final _googleSignInWeb = GoogleSignIn(clientId: _clientIDWeb, scopes: [
    'email',
    'profile',
  ],);

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();
  CtrlDomain ctrlDomain = CtrlDomain();

  Future<GoogleSignInAccount?> login() async {
    var _googleSignIn = _googleSignInWeb;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

    late String name, email, photoUrl;
    late GoogleSignInAccount? user;

    try {
      user = await _googleSignIn.signIn();
      if (user?.displayName != null) name = user!.displayName.toString();
      if (user?.email != null) email = user!.email.toString();
      if (user?.photoUrl != null) {
        photoUrl = user!.photoUrl.toString();
      } else {
        photoUrl = "https://i.stack.imgur.com/34AD2.jpg";
      }
    }catch(e) {
      print("error: --> " + e.toString());
    }

    await ctrlDomain.initializeUser(email, name, photoUrl);

    return user;
  }

  Future<GoogleSignInAccount?> logout() {
    var _googleSignIn = _googleSignInAndroid;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

    ctrlDomain.resetUserSystem();

    return _googleSignIn.disconnect();
  }

  Future<bool> isSignIn() async {
    var _googleSignIn = _googleSignInWeb;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

    return _googleSignIn.isSignedIn();
  }


}