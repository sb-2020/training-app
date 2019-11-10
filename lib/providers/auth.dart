import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async'; //for Timer
import 'dart:convert'; //for json.encode

enum UserType { Teacher, Resource }

class Auth with ChangeNotifier {
  String _phoneNumber;
  String _token;
  DateTime _expiryDate;
  UserType _userProfileType; //Teacher or Resource Person
  Timer _authTimer;

  String get token {
    if ((_token != null) &&
        (_expiryDate != null) &&
        (_expiryDate.isAfter(DateTime.now()))) {
      return _token;
    } else {
      return null;
    }
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  UserType get userType {
    return _userProfileType;
  }

  bool isUserAuthenticated() {
    //if a non-expired token exists,
    //it implies that the user is already authenticated
    return token != null;
  }

  Future<void> login(String phoneNumber, String password) async {
    //INTEGRATION TO DO: use http.post with the phone number and password
    //json encoded with the body in the body with json.encode should return
    //the token and user profile type

    //For now, using hardcoded data. Phone number 1111111111 for a teacher profile
    //and 2222222222 for a resource person profile
    print("inside login function");
    print(phoneNumber);
    print(password);

    if (phoneNumber == "1111111111") {
      _phoneNumber = "1111111111";
      _token = '12345';
      _expiryDate = DateTime.now().add(Duration(seconds: 600000));
      _userProfileType = UserType.Teacher;
    } else {
      _phoneNumber = "2222222222";
      _token = '56789';
      _expiryDate = DateTime.now().add(Duration(seconds: 600000));
      _userProfileType = UserType.Resource;
    }
    _autoLogout();
    notifyListeners();
    final loginSharedPrefs = await SharedPreferences.getInstance();
    final loginData = json.encode({
      'phoneNumber': _phoneNumber,
      'token': _token,
      'expiryDate': _expiryDate.toIso8601String(),
      'userProfileType':
          _userProfileType == UserType.Teacher ? "Teacher" : "Resource"
    });
    loginSharedPrefs.setString("LoginData", loginData);
  }

  Future<void> logout() async {
    _phoneNumber = null;
    _token = null;
    _expiryDate = null;
    _userProfileType = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final loginSharedPrefs = await SharedPreferences.getInstance();
    loginSharedPrefs.remove("LoginData");
  }

  void _autoLogout() {
    if (_expiryDate == null) return;
    if (_authTimer != null) {
      _authTimer.cancel();
    }

    final secondsToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: secondsToExpiry), logout);
  }

  Future<bool> attemptAutoLogin() async {
    final loginSharedPrefs = await SharedPreferences.getInstance();
    if (!loginSharedPrefs.containsKey("LoginData")) {
      return false;
    }

    final fetchedLoginData = json
        .decode(loginSharedPrefs.getString("LoginData")) as Map<String, Object>;
    final fetchedDate = DateTime.parse(fetchedLoginData["expiryDate"]);
    if (fetchedDate.isBefore(DateTime.now())) {
      return false;
    }
    _expiryDate = fetchedDate;
    _token = fetchedLoginData["token"];
    _phoneNumber = fetchedLoginData["phoneNumber"];
    if (fetchedLoginData["userProfileType"] == "Teacher") {
      _userProfileType = UserType.Teacher;
    } else {
      _userProfileType = UserType.Resource;
    }

    return true;
  }
}
