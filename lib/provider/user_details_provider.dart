import 'package:flutter/widgets.dart';

import '../model/validate_item.dart';

class UserDetailsProvider with ChangeNotifier {
  ValidationItem phoneNo = ValidationItem(null, null);
  ValidationItem firstName = ValidationItem(null, null);
  ValidationItem lastName = ValidationItem(null, null);
  ValidationItemDate dob = ValidationItemDate(null, null);
  ValidationItem password = ValidationItem(null, null);
  ValidationItem email = ValidationItem(null, null);
  ValidationItem profession = ValidationItem(null, null);

  ValidationItem get getPhoneNo => phoneNo;
  ValidationItem get getFirstName => firstName;
  ValidationItem get getLastName => lastName;
  ValidationItem get getPass => password;
  ValidationItem get getEmail => email;
  ValidationItem get getPro => profession;
  ValidationItemDate get getDOB => dob;

  bool get getSignInPhone => phoneNo.value == null ? false : true;
  bool get getSignInEmail =>
      email.value != null && password.value != null ? true : false;

  bool get getSignUp {
    if (getFirstName.value != null &&
        getPass.value != null &&
        getEmail.value != null)
      return true;
    else
      return false;
  }

  void destroyLoginValues() {
    email = ValidationItem(null, null);
    password = ValidationItem(null, null);
  }

  void changeFirstName(String value) {
    if (value.length >= 3) {
      firstName = ValidationItem(value, null);
    } else {
      firstName = ValidationItem(null, "يجب ألا يقل عن 3 أحرف");
    }
    notifyListeners();
  }

  void changeLastName(String value) {
    if (value.length >= 3) {
      lastName = ValidationItem(value, null);
    } else {
      lastName = ValidationItem(null, "يجب ألا يقل عن 3 أحرف");
    }
    notifyListeners();
  }

  void changePass(String value) {
    if (value.length >= 6) {
      password = ValidationItem(value, null);
    } else {
      password = ValidationItem(null, "يجب ألا يقل عن 6 أحرف");
    }
    notifyListeners();
  }

  void changeProfession(String value) {
    if (value.length >= 1) {
      profession = ValidationItem(value, null);
    } else {
      profession = ValidationItem(null, "يجب أن يتألف من حرف واحد على الأقل");
    }
    notifyListeners();
  }

  void changeEmail(String value) {
    if (value.length >= 3) {
      email = ValidationItem(value, null);
    } else {
      email = ValidationItem(null, "يجب ألا يقل عن 3 أحرف");
    }
    notifyListeners();
  }

  void changeDOB(String value) {
    notifyListeners();
  }

  void changeContactNo(String value) {
    if (value.length == 0) {
      phoneNo = ValidationItem(null, "*Mandatory");
    } else if (value.length >= 8) {
      phoneNo = ValidationItem(value, null);
    } else {
      phoneNo = ValidationItem(null, "يجب ألا يقل عن 8 أحرف");
    }
    notifyListeners();
  }
}
