import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  static final _clientIDWeb= "***REMOVED***";
  static final _clientIDAndroid = "***REMOVED***";

  static final _googleSignInAndroid = GoogleSignIn();
  static final _googleSignInWeb = GoogleSignIn(clientId: _clientIDWeb);

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();
  CtrlPresentation ctrlPresentation = CtrlPresentation();

  Future<GoogleSignInAccount?> login() {
    var _googleSignIn;
    if (defaultTargetPlatform == TargetPlatform.android) _googleSignIn = _googleSignInAndroid;
    else _googleSignIn = _googleSignInWeb;

    print("aaaaaaaaaaaa\n\n\n\n");
      final user = _googleSignIn.signIn();
      user.then((u) {
        ctrlPresentation.name = u?.displayName;
        ctrlPresentation.email = u?.email;
        ctrlPresentation.photoUrl = u?.photoUrl;
        print(u);
      });
      return user;
  }

  Future<GoogleSignInAccount?> logout() {
    var _googleSignIn;
    if (defaultTargetPlatform == TargetPlatform.android) _googleSignIn = _googleSignInAndroid;
    else _googleSignIn = _googleSignInWeb;

    final user = _googleSignIn.signOut();
    return user;
  }

  Future<bool> isSignIn() {
    var _googleSignIn;
    if (defaultTargetPlatform == TargetPlatform.android) _googleSignIn = _googleSignInAndroid;
    else _googleSignIn = _googleSignInWeb;

    return _googleSignIn.isSignedIn();
  }


}