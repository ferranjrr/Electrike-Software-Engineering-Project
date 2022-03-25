import 'package:flutter_project/interficie/ctrl_presentation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginAdpt {
  static final _instance = GoogleLoginAdpt._internal();
  var googleMapApiKey = "***REMOVED***";
  static final _clientIDWeb= "***REMOVED***";
  static final _clientIDAndroid = "***REMOVED***";
  static final _googleSignIn = GoogleSignIn(clientId: _clientIDWeb);

  factory GoogleLoginAdpt() {
    return _instance;
  }

  GoogleLoginAdpt._internal();
  CtrlPresentation ctrlPresentation = CtrlPresentation();

  Future<GoogleSignInAccount?> login() {
      final user = _googleSignIn.signIn();
      user.then((u) {
        ctrlPresentation.name = u?.displayName;
        ctrlPresentation.email = u?.email;
        ctrlPresentation.photoUrl = u?.photoUrl;
        print(ctrlPresentation.photoUrl);
      });
      return user;
  }

  Future<GoogleSignInAccount?> logout() {
    final user = _googleSignIn.disconnect();
    return user;
  }


}