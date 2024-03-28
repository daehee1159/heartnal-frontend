import 'dart:convert';

import 'package:couple_signal/src/models/inquiry/inquiry_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../global/global_variable.dart';

class Inquiry extends ChangeNotifier {
  int _inquirySeq = 0;
  set setInquirySeq(newValue) {
    _inquirySeq = newValue;
    notifyListeners();
  }
  int get getInquirySeq => _inquirySeq;

  int _memberSeq = 0;
  set setMemberSeq(newValue) {
    _memberSeq = newValue;
    notifyListeners();
  }
  int get getMemberSeq => _memberSeq;

  String _category = "";
  set setCategory(newValue) {
    _category = newValue;
    notifyListeners();
  }
  String get getCategory => _category;

  String _inquiries = "";
  set setInquiries(newValue) {
    _inquiries = newValue;
    notifyListeners();
  }
  String get getInquiries => _inquiries;

  String _inquiryDt = "";
  set setInquiryDt(newValue) {
    _inquiryDt = newValue;
    notifyListeners();
  }
  String get getInquiryDt => _inquiryDt;

  String _answerContent = "";
  set setAnswerContent(newValue) {
    _answerContent = newValue;
    notifyListeners();
  }
  String get getAnswerContent => _answerContent;

  String _answerDt = "";
  set setAnswerDt(newValue) {
    _answerDt = newValue;
    notifyListeners();
  }
  String get getAnswerDt => _answerDt;

  List<String> _categoryList = ["문의 유형A", "문의 유형B", "문의 유형C", "문의 유형D", "문의 유형E", "기타 문의"];
  List<String> get getCategoryList => _categoryList;

  getInquiryList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/inquiry/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<InquiryDto> fetchData =((json.decode(response.body) as List).map((e) => InquiryDto.fromJson(e)).toList());

    return fetchData;
  }

  setInquiry(String inquiryTitle, String inquiries) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/inquiry');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "inquiryTitle": inquiryTitle,
      "inquiries": inquiries
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    return result;
  }
}
