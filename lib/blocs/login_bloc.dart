import 'dart:convert';

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final FacebookLogin fbLogin = FacebookLogin();

  // StreamController
  final BehaviorSubject<String> _facebookResult = BehaviorSubject<String>();
  final BehaviorSubject<String> _userName = BehaviorSubject<String>();

  // Streams
  Stream<String> get facebookToken => _facebookResult.stream;

  Stream<String> get userName => _userName.stream;

  // Function
  Function(String) get changeUserName => _userName.sink.add;

  sigInFacebook() async {
    fbLogin.logInWithReadPermissions(['email']).then(
      (result) {
        switch (result.status) {
          case FacebookLoginStatus.loggedIn:
            {
              final token = result.accessToken.token;
              _facebookResult.sink.add(token);
              _getUserInfo(token).then(changeUserName);
              break;
            }
          case FacebookLoginStatus.error:
            {
              _facebookResult.addError("Facebook auth error");
              changeUserName('');
              break;
            }

          case FacebookLoginStatus.cancelledByUser:
            {
              _facebookResult.addError("Canceled by user");
              changeUserName('');
              break;
            }
        }
      },
    );
  }

  signOutFacebook() async {
    await fbLogin.logOut().then(_facebookResult.sink.add).then(changeUserName);
  }

  dispose() {
    _facebookResult.close();
    _userName.close();
  }
}

Future<String> _getUserInfo(String accessToken) async {
  var graphResponse =
      await http.get('https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$accessToken');
  final jsonResponse = json.decode(graphResponse.body);
  return jsonResponse['name'];
}
