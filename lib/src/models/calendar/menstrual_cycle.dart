import 'dart:convert';

import 'package:couple_signal/src/models/calendar/menstrual_cycle_calendar_dto.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle_dto.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle_message_dto.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenstrualCycle extends ChangeNotifier {
  int _menstrualCycleSeq = 0;
  set setMenstrualCycleSeq(newValue) {
    _menstrualCycleSeq = newValue;
    notifyListeners();
  }
  int get getMenstrualCycleSeq => _menstrualCycleSeq;

  String _lastMenstrualStartDt = "";
  set setLastMenstrualStartDt(newValue) {
    _lastMenstrualStartDt = newValue;
    notifyListeners();
  }
  String get getLastMenstrualStartDt => _lastMenstrualStartDt;

  int _menstrualCycle = 0;
  set setMenstrualCycle(newValue) {
    _menstrualCycle = newValue;
    notifyListeners();
  }
  int get getMenstrualCycle => _menstrualCycle;

  int _menstrualPeriod = 0;
  set setMenstrualPeriod(newValue) {
    _menstrualPeriod = newValue;
    notifyListeners();
  }
  int get getMenstrualPeriod => _menstrualPeriod;

  String _contraceptiveYN = "";
  set setContraceptiveYN(newValue) {
    _contraceptiveYN = newValue;
    notifyListeners();
  }
  String get getContraceptiveYN => _contraceptiveYN;

  String _takingContraceptiveDt = "";
  set setTakingContraceptiveDt(newValue) {
    _takingContraceptiveDt = newValue;
    notifyListeners();
  }
  String get getTakingContraceptiveDt => _takingContraceptiveDt;

  String _contraceptive = "";
  set setContraceptive(newValue) {
    _contraceptive = newValue;
    notifyListeners();
  }
  String get getContraceptive => _contraceptive;

  /// 여기서부터는 알림 메시지
  int _menstrualCycleMessageSeq = 0;
  set setMenstrualCycleMessageSeq(newValue) {
    _menstrualCycleMessageSeq = newValue;
    notifyListeners();
  }
  int get getMenstrualCycleMessageSeq => _menstrualCycleMessageSeq;

  String _menstruation3DaysAgoAlarm = "";
  set setMenstruation3DaysAgoAlarm(newValue) {
    _menstruation3DaysAgoAlarm = newValue;
    notifyListeners();
  }
  String get getMenstruation3DaysAgoAlarm => _menstruation3DaysAgoAlarm;

  String _menstruation3DaysAgo = "";
  set setMenstruation3DaysAgo(newValue) {
    _menstruation3DaysAgo = newValue;
    notifyListeners();
  }
  String get getMenstruation3DaysAgo => _menstruation3DaysAgo;

  String _menstruationDtAlarm = "";
  set setMenstruationDtAlarm(newValue) {
    _menstruationDtAlarm = newValue;
    notifyListeners();
  }
  String get getMenstruationDtAlarm => _menstruationDtAlarm;

  String _menstruationDt = "";
  set setMenstruationDt(newValue) {
    _menstruationDt = newValue;
    notifyListeners();
  }
  String get getMenstruationDt => _menstruationDt;

  String _ovulationDtAlarm = "";
  set setOvulationDtAlarm(newValue) {
    _ovulationDtAlarm = newValue;
    notifyListeners();
  }
  String get getOvulationDtAlarm => _ovulationDtAlarm;

  String _ovulationDt = "";
  set setOvulationDt(newValue) {
    _ovulationDt = newValue;
    notifyListeners();
  }
  String get getOvulationDt => _ovulationDt;

  String _fertileWindowStartDtAlarm = "";
  set setFertileWindowStartDtAlarm(newValue) {
    _fertileWindowStartDtAlarm = newValue;
    notifyListeners();
  }
  String get getFertileWindowStartDtAlarm => _fertileWindowStartDtAlarm;

  String _fertileWindowStartDt = "";
  set setFertileWindowStartDt(newValue) {
    _fertileWindowStartDt = newValue;
    notifyListeners();
  }
  String get getFertileWindowStartDt => _fertileWindowStartDt;

  String _fertileWindowsEndDtAlarm = "";
  set setFertileWindowsEndDtAlarm(newValue) {
    _fertileWindowsEndDtAlarm = newValue;
    notifyListeners();
  }
  String get getFertileWindowsEndDtAlarm => _fertileWindowsEndDtAlarm;

  String _fertileWindowsEndDt = "";
  set setFertileWindowsEndDt(newValue) {
    _fertileWindowsEndDt = newValue;
    notifyListeners();
  }
  String get getFertileWindowsEndDt => _fertileWindowsEndDt;

  /// 커플용 알림
  int _menstrualCycleToCoupleMessageSeq = 0;
  set setMenstrualCycleToCoupleMessageSeq(newValue) {
    _menstrualCycleToCoupleMessageSeq = newValue;
    notifyListeners();
  }
  int get getMenstrualCycleToCoupleMessageSeq => _menstrualCycleToCoupleMessageSeq;

  String _menstruation3DaysAgoToCoupleAlarm = "";
  set setMenstruation3DaysAgoToCoupleAlarm(newValue) {
    _menstruation3DaysAgoToCoupleAlarm = newValue;
    notifyListeners();
  }
  String get getMenstruation3DaysAgoToCoupleAlarm => _menstruation3DaysAgoToCoupleAlarm;

  String _menstruation3DaysAgoToCouple = "";
  set setMenstruation3DaysAgoToCouple(newValue) {
    _menstruation3DaysAgoToCouple = newValue;
    notifyListeners();
  }
  String get getMenstruation3DaysAgoToCouple => _menstruation3DaysAgoToCouple;

  String _menstruationDtToCoupleAlarm = "";
  set setMenstruationDtToCoupleAlarm(newValue) {
    _menstruationDtToCoupleAlarm = newValue;
    notifyListeners();
  }
  String get getMenstruationDtToCoupleAlarm => _menstruationDtToCoupleAlarm;

  String _menstruationDtToCouple = "";
  set setMenstruationDtToCouple(newValue) {
    _menstruationDtToCouple = newValue;
    notifyListeners();
  }
  String get getMenstruationDtToCouple => _menstruationDtToCouple;

  String _ovulationDtToCoupleAlarm = "";
  set setOvulationDtToCoupleAlarm(newValue) {
    _ovulationDtToCoupleAlarm = newValue;
    notifyListeners();
  }
  String get getOvulationDtToCoupleAlarm => _ovulationDtToCoupleAlarm;

  String _ovulationDtToCouple = "";
  set setOvulationDtToCouple(newValue) {
    _ovulationDtToCouple = newValue;
    notifyListeners();
  }
  String get getOvulationDtToCouple => _ovulationDtToCouple;

  String _fertileWindowStartDtToCoupleAlarm = "";
  set setFertileWindowStartDtToCoupleAlarm(newValue) {
    _fertileWindowStartDtToCoupleAlarm = newValue;
    notifyListeners();
  }
  String get getFertileWindowStartDtToCoupleAlarm => _fertileWindowStartDtToCoupleAlarm;

  String _fertileWindowStartDtToCouple = "";
  set setFertileWindowStartDtToCouple(newValue) {
    _fertileWindowStartDtToCouple = newValue;
    notifyListeners();
  }
  String get getFertileWindowStartDtToCouple => _fertileWindowStartDtToCouple;

  String _fertileWindowsEndDtToCoupleAlarm = "";
  set setFertileWindowsEndDtToCoupleAlarm(newValue) {
    _fertileWindowsEndDtToCoupleAlarm = newValue;
    notifyListeners();
  }
  String get getFertileWindowsEndDtToCoupleAlarm => _fertileWindowsEndDtToCoupleAlarm;

  String _fertileWindowsEndDtToCouple = "";
  set setFertileWindowsEndDtToCouple(newValue) {
    _fertileWindowsEndDtToCouple = newValue;
    notifyListeners();
  }
  String get getFertileWindowsEndDtToCouple => _fertileWindowsEndDtToCouple;

  ///
  late MenstrualCycleDto _menstrualCycleDto;
  set setMenstrualCycleDto(newValue) {
    _menstrualCycleDto = newValue;
    notifyListeners();
  }
  MenstrualCycleDto get getMenstrualCycleDto => _menstrualCycleDto;



  List _menuList = ["생리주기 평균일", "생리기간 평균일", "피임약 복용 여부", "나에게 알림", "상대에게 알림"];
  List get getMenuList => _menuList;

  Future<MenstrualCycleDto> getMenstrualCycleData() async {
    // API 호출로 생리주기 캘린더 정보 받아옴
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );


    MenstrualCycleDto nullDto = new MenstrualCycleDto(
      menstrualCycleSeq: 0,
      memberSeq: 0,
      coupleMemberSeq: 0,
      coupleCode: "",
      lastMenstrualStartDt: "",
      menstrualCycle: 0,
      menstrualPeriod: 0,
      contraceptiveYN: "",
      takingContraceptiveDt: "",
      contraceptive: "",
      regDt: ""
    );

    if (response.body == "") {
      this.setMenstrualCycleSeq = 0;
      this.setLastMenstrualStartDt = "";
      this.setMenstrualCycle = 0;
      this.setMenstrualPeriod = 0;
      this.setContraceptiveYN = "N";
      this.setTakingContraceptiveDt = "";
      this.setContraceptive = "CONTRACEPTIVE_NONE";
      return nullDto;
    } else {
      MenstrualCycleDto menstrualCycleDto = MenstrualCycleDto.fromJson(jsonDecode(response.body));
      this.setMenstrualCycleSeq = menstrualCycleDto.menstrualCycleSeq ?? 0;
      this.setLastMenstrualStartDt = menstrualCycleDto.lastMenstrualStartDt ?? "";
      this.setMenstrualCycle = menstrualCycleDto.menstrualCycle ?? 0;
      this.setMenstrualPeriod = menstrualCycleDto.menstrualPeriod ?? 0;
      this.setContraceptiveYN = menstrualCycleDto.contraceptiveYN ?? "N";
      this.setTakingContraceptiveDt = menstrualCycleDto.takingContraceptiveDt ?? "";
      this.setContraceptive = menstrualCycleDto.contraceptive ?? "CONTRACEPTIVE_NONE";

      return menstrualCycleDto;
    }
    // 여기서 알림설정 체크 안해도 될듯 알림 설정 눌렀을 때 여기서 가져온 데이터를 바탕으로 참조하면 될 듯

  }

  getMenstrualCycleCalendar() async {
    // API 호출로 생리주기 캘린더 정보 받아옴
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/calendar/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    MenstrualCycleCalendarDto calendarDto = MenstrualCycleCalendarDto.fromJson(jsonDecode(response.body));

    return calendarDto;
  }

  permissionCheck() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/permission/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  setMenstrualCycleData(String category, dynamic data) async {
    // 앞으로 set 할때 데이터 많이 필요하면 dto 만들어서 한번에 넘겨주는게 좋을 듯
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    String key = category;
    dynamic value = data;

    // if (key == "menstrualCycle" || key == "menstrualPeriod") {
    //   value = int.parse(value);
    // }

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
      key: value,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  updateMenstrualCycle(String category, dynamic data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/update');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    String key = category;
    dynamic value = data;

    if (key == "menstrualCycle" || key == "menstrualPeriod") {
      value = int.parse(value);
    }

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
      key: value,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  initMenstrualCycle() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/init/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  deleteMenstrualCycle() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/delete');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  setMenstrualCycleMessage(String alarmCategory, String alarm, String category, String data, String whoseData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/message');

    if (whoseData == "coupleData") {
      url = Uri.parse(Glob.calendarUrl + '/menstrual/couple/message');
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    String key = category;
    String value = data;

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
      alarmCategory: alarm,
      key: value,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    return result;
  }

  getMenstrualCycleMessage() async {
    // API 호출로 생리주기 캘린더 정보 받아옴
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/message/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    MenstrualCycleMessageDto nullDto = new MenstrualCycleMessageDto(
      menstrualCycleMessageSeq: 0,
      memberSeq: 0,
      coupleMemberSeq: 0,
      coupleCode: "",
      menstruation3DaysAgo: "",
      menstruationDt: "",
      ovulationDt: "",
      fertileWindowStartDt: "",
      fertileWindowsEndDt: "",
    );

    if (response.body == "") {
      this.setMenstrualCycleMessageSeq = 0;
      this.setMenstruation3DaysAgoAlarm = "N";
      this.setMenstruation3DaysAgo = "";
      this.setMenstruationDtAlarm = "N";
      this.setMenstruationDt = "";
      this.setOvulationDtAlarm = "N";
      this.setOvulationDt = "";
      this.setFertileWindowStartDt = "";
      this.setFertileWindowsEndDt = "";
      return nullDto;
    } else {
      MenstrualCycleMessageDto menstrualCycleMessageDto = MenstrualCycleMessageDto.fromJson(jsonDecode(response.body));
      this.setMenstrualCycleMessageSeq = menstrualCycleMessageDto.menstrualCycleMessageSeq ?? 0;
      if (menstrualCycleMessageDto.menstruation3DaysAgoAlarm == null || menstrualCycleMessageDto.menstruation3DaysAgoAlarm == "") {
        this.setMenstruation3DaysAgoAlarm = "N";
      } else {
        this.setMenstruation3DaysAgoAlarm = menstrualCycleMessageDto.menstruation3DaysAgoAlarm;
      }
      this.setMenstruation3DaysAgo = menstrualCycleMessageDto.menstruation3DaysAgo ?? "";

      if (menstrualCycleMessageDto.menstruationDtAlarm == null || menstrualCycleMessageDto.menstruationDtAlarm == "") {
        this.setMenstruationDtAlarm = "N";
      } else {
        this.setMenstruationDtAlarm = menstrualCycleMessageDto.menstruationDtAlarm;
      }
      this.setMenstruationDt = menstrualCycleMessageDto.menstruationDt ?? "";

      if (menstrualCycleMessageDto.ovulationDtAlarm == null || menstrualCycleMessageDto.ovulationDtAlarm == "") {
        this.setOvulationDtAlarm = "N";
      } else {
        this.setOvulationDtAlarm = menstrualCycleMessageDto.ovulationDtAlarm;
      }
      this.setOvulationDt = menstrualCycleMessageDto.ovulationDt ?? "";

      if (menstrualCycleMessageDto.fertileWindowStartDtAlarm == null || menstrualCycleMessageDto.fertileWindowStartDtAlarm == "") {
        this.setFertileWindowStartDtAlarm = "N";
      } else {
        this.setFertileWindowStartDtAlarm = menstrualCycleMessageDto.fertileWindowStartDtAlarm;
      }
      this.setFertileWindowStartDt = menstrualCycleMessageDto.fertileWindowStartDt ?? "";

      if (menstrualCycleMessageDto.fertileWindowsEndDtAlarm == null || menstrualCycleMessageDto.fertileWindowsEndDtAlarm == "") {
        this.setFertileWindowsEndDtAlarm = "N";
      } else {
        this.setFertileWindowsEndDtAlarm = menstrualCycleMessageDto.fertileWindowsEndDtAlarm;
      }
      this.setFertileWindowsEndDt = menstrualCycleMessageDto.fertileWindowsEndDt ?? "";

      return menstrualCycleMessageDto;
    }
  }

  getMenstrualCycleCoupleMessage() async {
    // API 호출로 생리주기 캘린더 정보 받아옴
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/couple/message/$memberSeq/$coupleCode');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    MenstrualCycleMessageDto nullDto = new MenstrualCycleMessageDto(
      menstrualCycleMessageSeq: 0,
      memberSeq: 0,
      coupleMemberSeq: 0,
      coupleCode: "",
      menstruation3DaysAgo: "",
      menstruationDt: "",
      ovulationDt: "",
      fertileWindowStartDt: "",
      fertileWindowsEndDt: "",
    );

    if (response.body == "") {
      this.setMenstrualCycleToCoupleMessageSeq = 0;
      this.setMenstruation3DaysAgoToCoupleAlarm = "N";
      this.setMenstruation3DaysAgoToCouple = "";
      this.setMenstruationDtToCoupleAlarm = "N";
      this.setMenstruationDtToCouple = "";
      this.setOvulationDtToCoupleAlarm = "N";
      this.setOvulationDtToCouple = "";
      this.setFertileWindowStartDtToCoupleAlarm = "N";
      this.setFertileWindowStartDtToCouple = "";
      this.setFertileWindowsEndDtToCoupleAlarm = "N";
      this.setFertileWindowsEndDtToCouple = "";
      return nullDto;
    } else {
      MenstrualCycleMessageDto menstrualCycleMessageDto = MenstrualCycleMessageDto.fromJson(jsonDecode(response.body));
      this.setMenstrualCycleToCoupleMessageSeq = menstrualCycleMessageDto.menstrualCycleMessageSeq ?? 0;

      if (menstrualCycleMessageDto.menstruation3DaysAgoAlarm == null || menstrualCycleMessageDto.menstruation3DaysAgoAlarm == "") {
        this.setMenstruation3DaysAgoToCoupleAlarm = "N";
      } else {
        this.setMenstruation3DaysAgoToCoupleAlarm = menstrualCycleMessageDto.menstruation3DaysAgoAlarm;
      }
      this.setMenstruation3DaysAgoToCouple = menstrualCycleMessageDto.menstruation3DaysAgo ?? "";

      if (menstrualCycleMessageDto.menstruationDtAlarm == null || menstrualCycleMessageDto.menstruationDtAlarm == "") {
        this.setMenstruationDtToCoupleAlarm = "N";
      } else {
        this.setMenstruationDtToCoupleAlarm = menstrualCycleMessageDto.menstruationDtAlarm;
      }
      this.setMenstruationDtToCouple = menstrualCycleMessageDto.menstruationDt ?? "";

      if (menstrualCycleMessageDto.ovulationDtAlarm == null || menstrualCycleMessageDto.ovulationDtAlarm == "") {
        this.setOvulationDtToCoupleAlarm = "N";
      } else {
        this.setOvulationDtToCoupleAlarm = menstrualCycleMessageDto.ovulationDtAlarm;
      }
      this.setOvulationDtToCouple = menstrualCycleMessageDto.ovulationDt ?? "";

      if (menstrualCycleMessageDto.fertileWindowStartDtAlarm == null || menstrualCycleMessageDto.fertileWindowStartDtAlarm == "") {
        this.setFertileWindowStartDtToCoupleAlarm = "N";
      } else {
        this.setFertileWindowStartDtToCoupleAlarm = menstrualCycleMessageDto.fertileWindowStartDtAlarm;
      }
      this.setFertileWindowStartDtToCouple = menstrualCycleMessageDto.fertileWindowStartDt ?? "";

      if (menstrualCycleMessageDto.fertileWindowsEndDtAlarm == null || menstrualCycleMessageDto.fertileWindowsEndDtAlarm == "") {
        this.setFertileWindowsEndDtToCoupleAlarm = "N";
      } else {
        this.setFertileWindowsEndDtToCoupleAlarm = menstrualCycleMessageDto.fertileWindowsEndDtAlarm;
      }
      this.setFertileWindowsEndDtToCouple = menstrualCycleMessageDto.fertileWindowsEndDt ?? "";

      return menstrualCycleMessageDto;
    }
  }

  updateMenstrualCycleMessage(MenstrualCycleMessageDto menstrualCycleMessageDto) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/message/update');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "menstrualCycleMessageSeq": menstrualCycleMessageDto.menstrualCycleMessageSeq,
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
      "menstruation3DaysAgo": menstrualCycleMessageDto.menstruation3DaysAgo,
      "menstruationDt": menstrualCycleMessageDto.menstruationDt,
      "ovulationDt": menstrualCycleMessageDto.ovulationDt,
      "fertileWindowStartDt": menstrualCycleMessageDto.fertileWindowStartDt,
      "fertileWindowsEndDt": menstrualCycleMessageDto.fertileWindowsEndDt,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

  deleteMenstrualCycleMessage(int menstrualCycleMessageSeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var coupleCode = pref.getString(Glob.coupleCode);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.calendarUrl + '/menstrual/message/delete');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "menstrualCycleMessageSeq": menstrualCycleMessageSeq,
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    bool result = jsonDecode(response.body);

    if (result == true) {
      return true;
    } else {
      return false;
    }
  }

  initProvider() async {
    this.setMenstrualCycleSeq = 0;
    this.setLastMenstrualStartDt = "";
    this.setMenstrualCycle = 0;
    this.setMenstrualPeriod = 0;
    this.setContraceptiveYN = "";
    this.setTakingContraceptiveDt = "";
    this.setContraceptive = "";

    this.setMenstrualCycleMessageSeq = 0;
    this.setMenstruation3DaysAgoAlarm = "";
    this.setMenstruation3DaysAgo = "";
    this.setMenstruationDtAlarm = "";
    this.setMenstruationDt = "";
    this.setOvulationDtAlarm = "";
    this.setOvulationDt = "";
    this.setFertileWindowStartDtAlarm = "";
    this.setFertileWindowStartDt = "";
    this.setFertileWindowsEndDtAlarm = "";
    this.setFertileWindowsEndDt = "";

    this.setMenstrualCycleToCoupleMessageSeq = 0;
    this.setMenstruation3DaysAgoToCoupleAlarm = "";
    this.setMenstruation3DaysAgoToCouple = "";
    this.setMenstruationDtToCoupleAlarm = "";
    this.setMenstruationDtToCouple = "";
    this.setOvulationDtToCoupleAlarm = "";
    this.setOvulationDtToCouple = "";
    this.setFertileWindowStartDtToCoupleAlarm = "";
    this.setFertileWindowStartDtToCouple = "";
    this.setFertileWindowsEndDtToCoupleAlarm = "";
    this.setFertileWindowsEndDtToCouple = "";
  }

  getMenuIcon(category) {
    var icon;
    switch (category) {
      case "생리주기 평균일":
        icon = FontAwesomeIcons.businessTime;
        break;
      case "생리기간 평균일":
        icon = FontAwesomeIcons.clock;
        break;
      case "피임약 복용 여부":
        icon = FontAwesomeIcons.cakeCandles;
        break;
      case "나에게 알림":
        icon = FontAwesomeIcons.heartPulse;
        break;
      case "상대에게 알림":
        icon = Icons.volunteer_activism;
        break;
    }
    return icon;
  }


}
