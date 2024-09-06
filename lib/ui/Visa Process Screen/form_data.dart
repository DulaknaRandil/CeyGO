import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class FormData with ChangeNotifier {
  // Controllers for Contact Information
  String? caddress;
  String? ccity;
  String? cstate;
  String? cpostal;
  String? ccountry;
  String? cais;
  String? cemail;
  String? cmn;

  // Controllers for Travel Information
  String? travelHis;
  String? reqDays;
  String? iADD;
  String? iADM;
  String? iADY;
  String? pOV;
  String? fNo;
  String? Opt;

  // Controllers for Declaration Information
  String? selopt1;
  String? selopt2;
  String? selopt3;

  // Decode base64 to image
  Uint8List? decodeBase64Image(String? base64String) {
    if (base64String == null) return null;
    return base64Decode(base64String);
  }

//Update Contact Information
  void updateCAddress(String value) {
    caddress = value;
    notifyListeners();
  }

  void updateCCity(String value) {
    ccity = value;
    notifyListeners();
  }

  void updateCState(String value) {
    cstate = value;
    notifyListeners();
  }

  void updateCPostal(String value) {
    cpostal = value;
    notifyListeners();
  }

  void updateCCountry(String value) {
    ccountry = value;
    notifyListeners();
  }

  void updateCAis(String value) {
    cais = value;
    notifyListeners();
  }

  void updateCEmail(String value) {
    cemail = value;
    notifyListeners();
  }

  void updateCMn(String value) {
    cmn = value;
    notifyListeners();
  }

  //Update Travel Information
  void updateTravelHis(String value) {
    travelHis = value;
    notifyListeners();
  }

  void updateReqDays(String value) {
    reqDays = value;
    notifyListeners();
  }

  void updateIAdd(String value) {
    iADD = value;
    notifyListeners();
  }

  void updateIAdm(String value) {
    iADM = value;
    notifyListeners();
  }

  void updateIADY(String value) {
    iADY = value;
    notifyListeners();
  }

  void updatePOV(String value) {
    pOV = value;
    notifyListeners();
  }

  void updateOption(String value) {
    Opt = value;
    notifyListeners();
  }

  void updateFNo(String value) {
    fNo = value;
    notifyListeners();
  }

  //Update Declaration Information
  void updateopt1(String value) {
    selopt1 = value;
    notifyListeners();
  }

  void updateopt2(String value) {
    selopt2 = value;
    notifyListeners();
  }

  void updateopt3(String value) {
    selopt3 = value;
    notifyListeners();
  }

//Clear Adult/child Information
  void clear() {
    notifyListeners();
  }

  Map<String, String?> getAllData() {
    return {
      // Contact Information
      'caddress': caddress,
      'ccity': ccity,
      'cstate': cstate,
      'cpostal': cpostal,
      'ccountry': ccountry,
      'cais': cais,
      'cemail': cemail,
      'cmn': cmn,

      // Travel Information
      'travelHis': travelHis,
      'reqDays': reqDays,
      'iADD': iADD,
      'iADM': iADM,
      'iADY': iADY,
      'pOV': pOV,
      'fNo': fNo,
      'Opt': Opt,

      // Declaration Information
      'selopt1': selopt1,
      'selopt2': selopt2,
      'selopt3': selopt3,
    };
  }

//Clear Contact Details
  void clearcontact() {
    caddress = null;
    ccity = null;
    cstate = null;
    cpostal = null;
    ccountry = null;
    cais = null;
    cemail = null;
    cmn = null;
  }
}
