// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  static const _clientIDWeb= "***REMOVED***";
  //static const _clientIDAndroid = "***REMOVED***";

  static final _googleSignInAndroid = GoogleSignIn();
  static final _googleSignInWeb = GoogleSignIn(clientId: _clientIDWeb);

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();
  CtrlPresentation ctrlPresentation = CtrlPresentation();

  Future<GoogleSignInAccount?> login() {
    var _googleSignIn = _googleSignInWeb;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

      final user = _googleSignIn.signIn();
      user.then((u) {
        if(u?.displayName != null) ctrlPresentation.name = u!.displayName.toString();
        if(u?.email != null) ctrlPresentation.email = u!.email.toString();
        if(u?.photoUrl != null) ctrlPresentation.photoUrl = u!.photoUrl.toString();
      });
      return user;
  }

  Future<GoogleSignInAccount?> logout() {
    var _googleSignIn = _googleSignInAndroid;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

    final user = _googleSignIn.signOut();
    return user;
  }

  Future<bool> isSignIn() {
    var _googleSignIn = _googleSignInWeb;
    if (defaultTargetPlatform == TargetPlatform.android) {
      _googleSignIn = _googleSignInAndroid;
    }

    return _googleSignIn.isSignedIn();
  }


}