import 'dart:convert';

import 'package:couple_signal/src/models/calendar/calendar_dto.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle_calendar_dto.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';

import '../../models/calendar/menstrual_cycle_dto.dart';
import '../../models/global/global_variable.dart';

Map<DateTime, List<String>> _fetchData = {};
Map<DateTime, List<String>> _calendarData = {};

class MenstrualCycleCalendar extends StatefulWidget {
  const MenstrualCycleCalendar({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleCalendar> createState() => _MenstrualCycleCalendarState();
}

class _MenstrualCycleCalendarState extends State<MenstrualCycleCalendar> {
  late Future fetchData;

  Map<DateTime, List<String>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  var colorList = [Colors.blue, Colors.pinkAccent, Colors.brown, Colors.green];
  List colorsData = [Colors.blue.withOpacity(0.5), Colors.pinkAccent.withOpacity(0.5), Colors.purpleAccent.withOpacity(0.5), Colors.cyanAccent.withOpacity(0.5), Colors.green.withOpacity(0.5), Colors.orange.withOpacity(0.5), Colors.grey.withOpacity(0.5), Colors.brown.withOpacity(0.5),];
  int selectedColor = 0;

  TextEditingController _eventController = TextEditingController();
  @override
  void initState() {
    super.initState();
    selectedEvents = {};
    fetchData = _getCalendar();
    _eventController.clear();
  }

  List<String> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    return FutureBuilder(
      future: fetchData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator()
                  ],
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          );
        } else {
          selectedEvents = _fetchData;
          Color colors = Colors.yellow;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "생리주기 캘린더",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              elevation: 0.0,
            ),
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    calendarBuilders: CalendarBuilders(
                        markerBuilder: (BuildContext context, date, events) {
                          bool isColor = false;
                          if (events.isEmpty) return SizedBox();
                          MenstrualCycleCalendarDto dto = snapshot.data;

                          DateTime beforeMenstrualCycleStartDt = DateTime.parse(dto.beforeMenstrualCycleStartDt.toString());
                          DateTime beforeMenstrualCycleEndDt = DateTime.parse(dto.beforeMenstrualCycleEndDt.toString());
                          List<DateTime> beforeMenstrualCyclePeriodDateList = getDaysInBetween(beforeMenstrualCycleStartDt, beforeMenstrualCycleEndDt);

                          if (beforeMenstrualCyclePeriodDateList.contains(date)) {
                            isColor = true;
                            colors = Colors.pinkAccent.withOpacity(0.5);
                          }

                          DateTime menstrualCycleStartDt = DateTime.parse(dto.menstrualCycleStartDt.toString());
                          DateTime menstrualCycleEndDt = DateTime.parse(dto.menstrualCycleEndDt.toString());
                          List<DateTime> menstrualCyclePeriodDateList = getDaysInBetween(menstrualCycleStartDt, menstrualCycleEndDt);

                          if (menstrualCyclePeriodDateList.contains(date)) {
                            isColor = true;
                            colors = Colors.pinkAccent.withOpacity(0.5);
                          }

                          DateTime afterMenstrualCycleStartDt = DateTime.parse(dto.afterMenstrualCycleStartDt.toString());
                          DateTime afterMenstrualCycleEndDt = DateTime.parse(dto.afterMenstrualCycleEndDt.toString());
                          List<DateTime> afterMenstrualCyclePeriodDateList = getDaysInBetween(afterMenstrualCycleStartDt, afterMenstrualCycleEndDt);

                          if (afterMenstrualCyclePeriodDateList.contains(date)) {
                            isColor = true;
                            colors = Colors.pinkAccent.withOpacity(0.5);
                          }

                          DateTime fertileWindowStartDt = DateTime.parse(dto.fertileWindowStartDt.toString());
                          DateTime fertileWindowEndDt = DateTime.parse(dto.fertileWindowEndDt.toString());
                          List<DateTime> fertileWindowPeriodDateList = getDaysInBetween(fertileWindowStartDt, fertileWindowEndDt);

                          if (fertileWindowPeriodDateList.contains(date)) {
                            isColor = true;
                            colors = Color(0xffF7C8BB).withOpacity(0.5);
                          }

                          DateTime afterFertileWindowStartDt = DateTime.parse(dto.afterFertileWindowStartDt.toString());
                          DateTime afterFertileWindowEndDt = DateTime.parse(dto.afterFertileWindowEndDt.toString());
                          List<DateTime> afterFertileWindowPeriodDateList = getDaysInBetween(afterFertileWindowStartDt, afterFertileWindowEndDt);

                          if (afterFertileWindowPeriodDateList.contains(date)) {
                            isColor = true;
                            colors = Color(0xffF7C8BB).withOpacity(0.5);
                          }

                          DateTime ovulationDt = DateTime.parse(dto.ovulationDt.toString());

                          if (ovulationDt == date) {
                            isColor = true;
                            colors = Color(0xffFE9BE6).withOpacity(0.5);
                          }

                          DateTime afterOvulationDt = DateTime.parse(dto.afterOvulationDt.toString());

                          if (afterOvulationDt == date) {
                            isColor = true;
                            colors = Color(0xffFE9BE6).withOpacity(0.5);
                          }

                          /// 기간 일정인지 아닌지에 따라 Positioned를 넣어줌
                          return Stack(
                            children: [
                              Center(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                                      padding: EdgeInsets.all(1),
                                      child: Container(
                                        width: 6,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // 지금 이게 isPeriod랑 같은 의미임
                              (isColor == true) ?
                              Positioned(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(vertical: 13.0),
                                      width: MediaQuery.of(context).size.width * 0.5,
                                      height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: colors,
                                      ),
                                    );
                                  },
                                ),
                              ) : SizedBox()
                            ],
                          );
                        }
                    ),
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    locale: 'ko-KR',
                    calendarFormat: format,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    startingDayOfWeek: StartingDayOfWeek.sunday,
                    daysOfWeekVisible: true,

                    // day changed
                    onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                    },

                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(selectedDay, date);
                    },
                    eventLoader: _getEventsfromDay,

                    // to style the calendar
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      selectedDecoration: BoxDecoration(
                        color: Color(0xffFE9BE6).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.black,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Color(0xffFE9BE6).withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: TextStyle(
                        color: Colors.black
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: TextStyle(
                        color: Colors.black,
                      ),

                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      formatButtonShowsNext: true,
                      leftChevronVisible: true,
                      rightChevronVisible: true,
                    ),
                  ),
                  ..._getEventsfromDay(selectedDay).map((String event) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      margin: EdgeInsets.fromLTRB(3, 10, 3, 3),
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0,
                              color: const Color(0xff494749)
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(13.0)
                          )
                      ),
                      child: ListTile(
                        title: Text(
                          event.toString(),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        trailing: TextButton(
                          child: Text(
                            '',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onPressed: () {
                          },
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
          );
        }
      },
    );
  }

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

      days.add(DateTime.parse(date.year.toString() + "-" + realMonth + "-" + realDay + " 00:00:00.000Z"));
    }
    return days;
  }

  _getCalendar() async {
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


    /// 초기화, 초기화를 하지 않으면 이 맵에 계속 + 되어서 쌓임
    _calendarData = {};

    /// 이전 생리날짜, 다음 생리 시작일, 종료일, 그 다음 생리 시작일, 종료일

    /// 이전 생리 날짜
    DateTime beforeMenstrualCycleStartDt = DateTime.parse(calendarDto.beforeMenstrualCycleStartDt.toString());
    DateTime beforeMenstrualCycleEndDt = DateTime.parse(calendarDto.beforeMenstrualCycleEndDt.toString());

    List<DateTime> beforeMenstrualCycleList = getDaysInBetween(beforeMenstrualCycleStartDt, beforeMenstrualCycleEndDt);

    // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
    for (int j = 0; j < beforeMenstrualCycleList.length; j++) {
      if (_calendarData.containsKey(beforeMenstrualCycleList[j])) {
        /// 중복인 경우
        _calendarData.keys.firstWhere((key) {
          if (key == beforeMenstrualCycleList[j]) {
            List<String> valueList = _calendarData[key]!;
            valueList.add(calendarDto.beforeMenstrualCycleMemo.toString());
            _calendarData[key] = valueList;
            return true;
          } else {
            return false;
          }
        });
      } else {
        /// 중복이 아닌 경우
        List<String> valueList = [];
        valueList.add(calendarDto.beforeMenstrualCycleMemo.toString());
        Map<DateTime, List<String>> resultTemp = {beforeMenstrualCycleList[j] : valueList};
        _calendarData.addAll(resultTemp);
      }
    }

    /// 이번 생리 날짜
    DateTime menstrualCycleStartDt = DateTime.parse(calendarDto.menstrualCycleStartDt.toString());
    DateTime menstrualCycleEndDt = DateTime.parse(calendarDto.menstrualCycleEndDt.toString());

    List<DateTime> menstrualCycleDtList = getDaysInBetween(menstrualCycleStartDt, menstrualCycleEndDt);

    // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
    for (int j = 0; j < menstrualCycleDtList.length; j++) {
      if (_calendarData.containsKey(menstrualCycleDtList[j])) {
        /// 중복인 경우
        _calendarData.keys.firstWhere((key) {
          if (key == menstrualCycleDtList[j]) {
            List<String> valueList = _calendarData[key]!;
            valueList.add(calendarDto.menstrualCycleMemo.toString());
            _calendarData[key] = valueList;
            return true;
          } else {
            return false;
          }
        });
      } else {
        /// 중복이 아닌 경우
        List<String> valueList = [];
        valueList.add(calendarDto.menstrualCycleMemo.toString());
        Map<DateTime, List<String>> resultTemp = {menstrualCycleDtList[j] : valueList};
        _calendarData.addAll(resultTemp);
      }
    }

    /// 다음 생리 날짜
    DateTime afterMenstrualCycleStartDt = DateTime.parse(calendarDto.afterMenstrualCycleStartDt.toString());
    DateTime afterMenstrualCycleEndDt = DateTime.parse(calendarDto.afterMenstrualCycleEndDt.toString());

    List<DateTime> afterMenstrualCycleDtListList = getDaysInBetween(afterMenstrualCycleStartDt, afterMenstrualCycleEndDt);

    // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
    for (int j = 0; j < afterMenstrualCycleDtListList.length; j++) {
      if (_calendarData.containsKey(afterMenstrualCycleDtListList[j])) {
        /// 중복인 경우
        _calendarData.keys.firstWhere((key) {
          if (key == afterMenstrualCycleDtListList[j]) {
            List<String> valueList = _calendarData[key]!;
            valueList.add(calendarDto.menstrualCycleMemo.toString());
            _calendarData[key] = valueList;
            return true;
          } else {
            return false;
          }
        });
      } else {
        /// 중복이 아닌 경우
        List<String> valueList = [];
        valueList.add(calendarDto.menstrualCycleMemo.toString());
        Map<DateTime, List<String>> resultTemp = {afterMenstrualCycleDtListList[j] : valueList};
        _calendarData.addAll(resultTemp);
      }
    }


    /// 배란일
    if (_calendarData.containsKey(DateTime.parse(calendarDto.ovulationDt.toString()))) {
      _calendarData.keys.firstWhere((key) {
        if (key == DateTime.parse(calendarDto.ovulationDt.toString())) {
          List<String> valueList = _calendarData[key]!;
          valueList.add(calendarDto.ovulationDtMemo.toString());
          _calendarData[key] = valueList;
          return true;
        } else {
          return false;
        }
      });
    } else {
      List<String> valueList = [];
      valueList.add(calendarDto.ovulationDtMemo.toString());
      Map<DateTime, List<String>> resultTemp = {DateTime.parse(calendarDto.ovulationDt.toString()) : valueList};
      _calendarData.addAll(resultTemp);
    }

    if (_calendarData.containsKey(DateTime.parse(calendarDto.afterOvulationDt.toString()))) {
      _calendarData.keys.firstWhere((key) {
        if (key == DateTime.parse(calendarDto.afterOvulationDt.toString())) {
          List<String> valueList = _calendarData[key]!;
          valueList.add(calendarDto.afterOvulationDtMemo.toString());
          _calendarData[key] = valueList;
          return true;
        } else {
          return false;
        }
      });
    } else {
      List<String> valueList = [];
      valueList.add(calendarDto.afterOvulationDtMemo.toString());
      Map<DateTime, List<String>> resultTemp = {DateTime.parse(calendarDto.afterOvulationDt.toString()) : valueList};
      _calendarData.addAll(resultTemp);
    }

    /// 가임기 시작일, 종료일
    DateTime fertileWindowStartDt = DateTime.parse(calendarDto.fertileWindowStartDt.toString());
    DateTime fertileWindowEndDt = DateTime.parse(calendarDto.fertileWindowEndDt.toString());

    List<DateTime> fertileWindowDtListList = getDaysInBetween(fertileWindowStartDt, fertileWindowEndDt);

    // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
    for (int j = 0; j < fertileWindowDtListList.length; j++) {
      if (_calendarData.containsKey(fertileWindowDtListList[j])) {
        /// 중복인 경우
        _calendarData.keys.firstWhere((key) {
          if (key == fertileWindowDtListList[j]) {
            List<String> valueList = _calendarData[key]!;
            valueList.add(calendarDto.fertileWindowMemo.toString());
            _calendarData[key] = valueList;
            return true;
          } else {
            /// 여기서 문제가 생김 no element
            return false;
          }
        });
      } else {
        /// 중복이 아닌 경우
        List<String> valueList = [];
        valueList.add(calendarDto.fertileWindowMemo.toString());
        Map<DateTime, List<String>> resultTemp = {fertileWindowDtListList[j] : valueList};
        _calendarData.addAll(resultTemp);
      }
    }

    DateTime afterFertileWindowStartDt = DateTime.parse(calendarDto.afterFertileWindowStartDt.toString());
    DateTime afterFertileWindowEndDt = DateTime.parse(calendarDto.afterFertileWindowEndDt.toString());

    List<DateTime> afterFertileWindowDtListList = getDaysInBetween(afterFertileWindowStartDt, afterFertileWindowEndDt);

    // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
    for (int j = 0; j < afterFertileWindowDtListList.length; j++) {
      if (_calendarData.containsKey(afterFertileWindowDtListList[j])) {
        /// 중복인 경우
        _calendarData.keys.firstWhere((key) {
          if (key == afterFertileWindowDtListList[j]) {
            List<String> valueList = _calendarData[key]!;
            valueList.add(calendarDto.afterFertileWindowMemo.toString());
            _calendarData[key] = valueList;
            return true;
          } else {
            return false;
          }
        });
      } else {
        /// 중복이 아닌 경우
        List<String> valueList = [];
        valueList.add(calendarDto.afterFertileWindowMemo.toString());
        Map<DateTime, List<String>> resultTemp = {afterFertileWindowDtListList[j] : valueList};
        _calendarData.addAll(resultTemp);
      }
    }

    _fetchData = _calendarData;

    return calendarDto;
  }

  noPermissionAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "권한 없음",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '정보를 등록한 분만 접근이 가능해요!',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }
}
