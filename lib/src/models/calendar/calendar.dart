import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'calendar_dto.dart';

class Calendar extends ChangeNotifier {
  bool _loading = true;
  set setLoading(newValue) {
    _loading = newValue;
    notifyListeners();
  }
  bool get getLoading => _loading;

  Map<DateTime, List<String>> _calendarData = {};
  set setCalendarData(Map<DateTime, List<String>> newValue) {
    _calendarData.addAll(newValue);
    notifyListeners();
  }
  Map<DateTime, List<String>> get getCalendarData => _calendarData;

  Future<Map<DateTime, List<String>>> fetchData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/calendar/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<CalendarDto> calendarDto = ((json.decode(response.body) as List).map((e) => CalendarDto.fromJson(e)).toList());

    List<DateTime> datetimeList = [];

    Map<DateTime, List<String>> result = {};

    List<CalendarDto> tempDto = [];

    for (int i = 0; i < calendarDto.length; i++) {
      /// 여기서는 무조건 1:N으로 넣어줘야함 그래야 해당 날짜를 클릭했을 때 메모 리스트를 볼 수 있음
      if (calendarDto[i].isPeriod) {
        DateTime startDt = DateTime.parse(calendarDto[i].startDt.toString());
        DateTime endDt = DateTime.parse(calendarDto[i].endDt.toString());

        List<DateTime> periodDateList = getDaysInBetween(startDt, endDt);

        // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함

        for (int j = 0; j < periodDateList.length; j++) {
          // Map<DateTime, String> tempPeriodMap = {};
          // tempPeriodMap[periodDateList[j]] = calendarDto[i].memo.toString();
          // tempDto.add(tempPeriodMap);

          if (result.containsKey(periodDateList[j])) {
            result.keys.firstWhere((key) {
              if (key == periodDateList[j]) {
                List<String> valueList = result[key]!;
                valueList.add(calendarDto[i].memo.toString());
                result[key] = valueList;
                return true;
              } else {
                return false;
              }
            });
          } else {
            List<String> valueList = [];
            valueList.add(calendarDto[i].memo.toString());
            Map<DateTime, List<String>> resultTemp = {periodDateList[j] : valueList};
            _calendarData.addAll(resultTemp);
          }
          // datetimeList.add(periodDateList[j]);
        }

        // for (int k = 0; k < calendarDto.length; k++) {
        //
        //
        //   // periodDateList.where((date) {
        //   //   if (date != DateTime.parse(calendarDto[k].startDt.toString())) {
        //   //     datetimeList.add(DateTime.parse(calendarDto[k].startDt.toString()));
        //   //   }
        //   // });
        // }
      } else {
        if (result.containsKey(calendarDto[i].startDt)) {
          result.keys.firstWhere((key) {
            if (key == DateTime.parse(calendarDto[i].startDt.toString())) {
              List<String> valueList = result[key]!;
              valueList.add(calendarDto[i].memo.toString());
              result[key] = valueList;
              return true;
            } else {
              return false;
            }
          });
        } else {
          List<String> valueList = [];
          valueList.add(calendarDto[i].memo.toString());
          Map<DateTime, List<String>> resultTemp = {DateTime.parse(calendarDto[i].startDt.toString()) : valueList};
          _calendarData.addAll(resultTemp);
        }
      }

      // DateTime dateTime = DateTime.parse(calendarDto[i].datetime.toString());
      // // DateTime dateTime = DateTime.parse(calendarDto[i].datetime.toString());
      // List<String> testList = [];
      // for (int j = 0; j < calendarDto[i].memoLists!.length; j++) {
      //   testList.add(calendarDto[i].memoLists![j].memo.toString());
      // }
      // Map<DateTime, List<String>> test = {dateTime : testList};
      // _calendarData.addAll(test);
    }

    notifyListeners();

    return _calendarData;
  }

  /// 두 날짜 사이의 날짜들 구하기
  List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    String realMonth = "";
    String realDay = "";
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      DateTime date = startDate.add(Duration(days: i));

      if (date.month < 10) {
        realMonth = "0" + date.month.toString();
      } else {
        realMonth = date.month.toString();
      }

      if ((date.day) < 10) {
        realDay = "0" + (date.day).toString();
      } else {
        realDay = (date.day).toString();
      }
      days.add(DateTime.parse(date.year.toString() + "-" + realMonth + "-" + realDay));

      // days.add(startDate.add(Duration(days: i)));

      // days.add(
      //     DateTime.parse(startDate.year.toString() + startDate.month.toString() + (startDate.day + i).toString())
      //     // DateTime(
      //     //     startDate.year,
      //     //     startDate.month,
      //     //     // In Dart you can set more than. 30 days, DateTime will do the trick
      //     //     startDate.day + i)
      // );
    }

    return days;
  }
}
