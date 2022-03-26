// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  static const _clientIDWeb= "***REMOVED***";
  //static const _clientIDAndroid = "***REMOVED***";
  static final _googleSignIn = GoogleSignIn(clientId: _clientIDWeb);

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();
  CtrlPresentation ctrlPresentation = CtrlPresentation();

  Future<GoogleSignInAccount?> login() {
      final user = _googleSignIn.signIn();
      user.then((u) {
        if(u?.displayName != null) ctrlPresentation.name = u!.displayName.toString();
        if(u?.email != null) ctrlPresentation.email = u!.email.toString();
        if(u?.photoUrl != null) ctrlPresentation.photoUrl = u!.photoUrl.toString();
      });
      return user;
  }

  Future<GoogleSignInAccount?> logout() {
    final user = _googleSignIn.signOut();
    return user;
  }

  Future<bool> isSignIn() {
    return _googleSignIn.isSignedIn();
  }


}