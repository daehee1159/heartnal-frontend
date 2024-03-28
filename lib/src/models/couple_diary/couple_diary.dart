import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CoupleDiary extends ChangeNotifier {
  final Storage storage = Storage();

  int? diarySeq;
  int? writerMemberSeq;
  String? coupleCode;

  String? contents;
  String? datetime;
  String? fileName1;
  String? fileName2;
  String? fileName3;
  int fileCount = 1;

  bool? likeYN;
  int? likeMember1;
  int? likeMember2;
  int? likeCount;

  String? regDt;

  List<CoupleDiary> coupleDiaryList = [];
  List<String> fileToUrlList = [];

  /// getter & setter
  int? get getDiarySeq => diarySeq;
  set setDiarySeq(int? newValue) {
    diarySeq = newValue;
    notifyListeners();
  }
  int? get getWriterMemberSeq => writerMemberSeq;
  set setWriterMemberSeq(int? newValue) {
    writerMemberSeq = newValue;
    notifyListeners();
  }
  String? get getCoupleCode => coupleCode;
  set setCoupleCode(String? newValue) {
    coupleCode = newValue;
    notifyListeners();
  }

  String? get getContents => contents;
  set setContents(String? newValue) {
    contents = newValue;
    notifyListeners();
  }
  String? get getDatetime => datetime;
  set setDatetime(String? newValue) {
    datetime = newValue;
    notifyListeners();
  }
  String? get getFileName1 => fileName1;
  set setFileName1(String? newValue) {
    fileName1 = newValue;
    notifyListeners();
  }
  String? get getFileName2 => fileName2;
  set setFileName2(String? newValue) {
    fileName2 = newValue;
    notifyListeners();
  }
  String? get getFileName3 => fileName3;
  set setFileName3(String? newValue) {
    fileName3 = newValue;
    notifyListeners();
  }
  int get getFileCount => fileCount;
  set setFileCount(int newValue) {
    fileCount = newValue;
    notifyListeners();
  }

  bool? get getLikeYN => likeYN;
  set setLikeYN(bool? newValue) {
    likeYN = newValue;
    notifyListeners();
  }
  int? get getLikeMember1 => likeMember1;
  set setLikeMember1(int? newValue) {
    likeMember1 = newValue;
    notifyListeners();
  }
  int? get getLikeMember2 => likeMember2;
  set setLikeMember2(int? newValue) {
    likeMember2 = newValue;
    notifyListeners();
  }
  int? get getLikeCount => likeCount;
  set setLikeCount(int? newValue) {
    likeCount = newValue;
    notifyListeners();
  }

  String? get getRegDt => regDt;
  set setRegDt(String? newValue) {
    regDt = newValue;
    notifyListeners();
  }

  List<CoupleDiary> get getCoupleDiaryList => coupleDiaryList;
  set setCoupleDiaryList(List<CoupleDiary> newValue) {
    coupleDiaryList = newValue;
    notifyListeners();
  }

  CoupleDiary({
    this.diarySeq,
    this.writerMemberSeq,
    this.coupleCode,

    this.contents,
    this.datetime,
    this.fileName1,
    this.fileName2,
    this.fileName3,

    this.likeYN,
    this.likeMember1,
    this.likeMember2,
    this.likeCount,

    this.regDt
  });

  CoupleDiary.fromJson(Map<String, dynamic> json) {
    diarySeq = json['diarySeq'];
    writerMemberSeq = json['writerMemberSeq'];
    coupleCode = json['coupleCode'];

    contents = json['contents'];
    datetime = json['datetime'];
    fileName1 = json['fileName1'];
    fileName2 = json['fileName2'];
    fileName3 = json['fileName3'];

    likeYN = json['likeYN'];
    likeMember1 = json['likeMember1'];
    likeMember2 = json['likeMember2'];
    likeCount = json['likeCount'];

    regDt = json['regDt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['diarySeq'] = this.diarySeq;
    data['writerMemberSeq'] = this.writerMemberSeq;
    data['coupleCode'] = this.coupleCode;

    data['contents'] = this.contents;
    data['datetime'] = this.datetime;
    data['fileName1'] = this.fileName1;
    data['fileName2'] = this.fileName2;
    data['fileName3'] = this.fileName3;

    data['likeYN'] = this.likeYN;
    data['likeMember1'] = this.likeMember1;
    data['likeMember2'] = this.likeMember2;
    data['likeCount'] = this.likeCount;

    data['regDt'] = this.regDt;

    return data;
  }

  Future<bool> checkCoupleDiaryAuthority(int diarySeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var writerMemberSeq = pref.getInt(Glob.memberSeq);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.coupleDiaryUrl + "/check/authority/$diarySeq/$writerMemberSeq");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.body == "true") {
      return true;
    } else {
      return false;
    }
  }

  setCoupleDiary(List<String> fileNameList, String contents, String datetime) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var writerMemberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.coupleDiaryUrl);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    switch (fileNameList.length) {
      case 1:
        postData = jsonEncode({
          "fileName1": fileNameList[0],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
      case 2:
        postData = jsonEncode({
          "fileName1": fileNameList[0],
          "fileName2": fileNameList[1],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
      case 3:
        postData = jsonEncode({
          "fileName1": fileNameList[0],
          "fileName2": fileNameList[1],
          "fileName3": fileNameList[2],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
    }

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData,
    );

    return jsonDecode(response.body);
  }

  getCoupleDiary() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var coupleCode = pref.getString(Glob.coupleCode);
    var memberSeq = pref.getInt(Glob.memberSeq);

    var url = Uri.parse(Glob.coupleDiaryUrl + '/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.body.isNotEmpty) {
      List<CoupleDiary> fetchData = ((json.decode(response.body) as List).map((e) => CoupleDiary.fromJson(e)).toList());
      return coupleDiaryList = fetchData;
    } else {
      return coupleDiaryList;
    }
  }

  fileUrlToList() async {
    List<String> fileUrlToList = [];
    switch(fileCount) {
      case 1:
        String fileUrl1 = await storage.downloadURL(fileName1.toString(), "couple_diary");
        fileUrlToList.add(fileUrl1);
        break;
      case 2:
        String fileUrl1 = await storage.downloadURL(fileName1.toString(), "couple_diary");
        String fileUrl2 = await storage.downloadURL(fileName2.toString(), "couple_diary");
        fileUrlToList.add(fileUrl1);
        fileUrlToList.add(fileUrl2);
        break;
      case 3:
        String fileUrl1 = await storage.downloadURL(fileName1.toString(), "couple_diary");
        String fileUrl2 = await storage.downloadURL(fileName2.toString(), "couple_diary");
        String fileUrl3 = await storage.downloadURL(fileName3.toString(), "couple_diary");
        fileUrlToList.add(fileUrl1);
        fileUrlToList.add(fileUrl2);
        fileUrlToList.add(fileUrl3);
        break;
    }
    this.fileToUrlList = fileUrlToList;
    return fileUrlToList;
  }

  updateCoupleDiary(int diarySeq, List<String> fileNameList, String contents, String datetime) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var writerMemberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.coupleDiaryUrl + "/update");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    switch (fileNameList.length) {
      case 1:
        postData = jsonEncode({
          "diarySeq": diarySeq,
          "fileName1": fileNameList[0],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
      case 2:
        postData = jsonEncode({
          "diarySeq": diarySeq,
          "fileName1": fileNameList[0],
          "fileName2": fileNameList[1],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
      case 3:
        postData = jsonEncode({
          "diarySeq": diarySeq,
          "fileName1": fileNameList[0],
          "fileName2": fileNameList[1],
          "fileName3": fileNameList[2],
          "contents": contents,
          "datetime": datetime,
          "writerMemberSeq": writerMemberSeq,
          "coupleCode": coupleCode,
        });
        break;
    }

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );

    return jsonDecode(response.body);

  }

  deleteCoupleDiary(int diarySeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var writerMemberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.coupleDiaryUrl + "/delete");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    final postData = jsonEncode({
      "diarySeq": diarySeq,
      "writerMemberSeq": writerMemberSeq,
      "coupleCode": coupleCode,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );

    return jsonDecode(response.body);
  }

  Future<bool> pressLike(int diarySeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.coupleDiaryUrl + "/like");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    final postData = jsonEncode({
      "diarySeq": diarySeq,
      "memberSeq": memberSeq,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );

    return jsonDecode(response.body);
  }
}
