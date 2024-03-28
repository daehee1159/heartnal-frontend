import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';

import 'package:couple_signal/src/models/calendar/calendar_dto.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Map<DateTime, List<String>> _fetchData = {};
Map<DateTime, List<String>> _calendarData = {};
String startDt = "";
String endDt = "";
DateTime startDtTemp = DateTime.now();
DateTime endDtTemp = DateTime.now();
List<CalendarDto> calendarDtoList = [];

class CoupleCalendar extends StatefulWidget {
  const CoupleCalendar({Key? key}) : super(key: key);

  @override
  State<CoupleCalendar> createState() => _CoupleCalendarState();
}

class _CoupleCalendarState extends State<CoupleCalendar> {
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
    startDt = "";
    endDt = "";
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
                "커플 공용 캘린더",
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
                          List<CalendarDto> dto = snapshot.data;

                          /// Color
                          dto.forEach((element) {
                            if (element.isPeriod == true) {
                              DateTime startDt = DateTime.parse(element.startDt.toString());
                              DateTime endDt = DateTime.parse(element.endDt.toString());

                              List<DateTime> periodDateList = getDaysInBetween(startDt, endDt);

                              if (periodDateList.contains(date)) {
                                isColor = true;
                                switch (element.color.toString()) {
                                  case "purpleAccent":
                                    colors = Colors.purpleAccent;
                                    break;
                                  case "green":
                                    colors = Colors.green;
                                    break;
                                  case "blue":
                                    colors = Colors.blue;
                                    break;
                                  case "pinkAccent":
                                    colors = Colors.pinkAccent;
                                    break;
                                  case "brown":
                                    colors = Colors.brown;
                                    break;
                                  case "grey":
                                    colors = Colors.grey;
                                    break;
                                  case "cyanAccent":
                                    colors = Colors.cyanAccent;
                                    break;
                                  case "orange":
                                    colors = Colors.orange;
                                    break;
                                }
                              }
                            }
                          });

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
                                        color: colors.withOpacity(0.5),
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
                        color: const Color(0xffFE9BE6),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: TextStyle(
                        color: Colors.white,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      defaultDecoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      weekendDecoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                            '삭제',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      AlertDialog alertDialog = AlertDialog(
                                        title: TextButton.icon(
                                          label: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                            child: Text(
                                              "일정 삭제",
                                              style: Theme.of(context).textTheme.bodyText1,
                                            ),
                                          ),
                                          icon: Icon(
                                            FontAwesomeIcons.exclamationCircle,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {},
                                        ),
                                        content: Text(
                                          '삭제 후에는 복구가 불가능해요.\n그래도 삭제할까요?',
                                          style: Theme.of(context).textTheme.bodyText2,
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          TextButton(
                                            child: Text(
                                              '삭제',
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                            onPressed: () async {
                                              calendarDtoList.forEach((dto) async {
                                                if (dto.memo == event && dto.isPeriod == true) {
                                                  DateTime startDate = DateTime.parse(dto.startDt.toString());
                                                  DateTime endDate = DateTime.parse(dto.endDt.toString());
                                                  List<DateTime> dayList = getDaysInBetween(startDate, endDate);

                                                  if (dayList.contains(selectedDay)) {
                                                    bool result = await _deleteCalendar(dto.calendarSeq, startDate, endDate, event);
                                                    if (result) {
                                                      Navigator.of(context).pop();
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 3,)));
                                                    } else {
                                                      GlobalAlert().globErrorAlert(context);
                                                    }
                                                  }
                                                } else if (dto.memo == event && dto.isPeriod == false) {
                                                  if (selectedDay.toString() == dto.startDt) {
                                                    bool result = await _deleteCalendar(dto.calendarSeq, DateTime.parse(dto.startDt.toString()), DateTime.parse(dto.endDt.toString()), event);
                                                    if (result) {
                                                      Navigator.of(context).pop();
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 3,)));
                                                    } else {
                                                      GlobalAlert().globErrorAlert(context);
                                                    }
                                                  }
                                                }
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              '취소',
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                      return alertDialog;
                                    },
                                  );
                                }
                            );
                          },
                        ),
                      ),
                    ),
                  ))
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: const Color(0xffFE9BE6),
              onPressed: () {
                // null 체크 꼭 필요함
                if (selectedEvents[selectedDay] != null && selectedEvents[selectedDay]!.length >= 3) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: TextButton.icon(
                          label: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              "등록 불가",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                          icon: Icon(
                            FontAwesomeIcons.exclamationCircle,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                        content: Text(
                          '일정은 3개까지 등록이 가능해요.',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        actions: [
                          TextButton(
                            child: Text(
                              'OK',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      )
                  );
                } else {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20.0)
                        )
                    ),
                    context: context,
                    builder: (context) => buildSheet(context),
                  ).whenComplete(() {
                    /// modal 닫혔을 때 기본 컬러로 변경
                    selectedColor = 0;
                    _eventController.text = "";
                    startDtTemp = DateTime.now();
                    endDtTemp = DateTime.now();
                    startDt = "";
                    endDt = "";
                  });
                }
              },
              label: Text(
                '일정 추가',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
              ),
              icon: const Icon(Icons.add),
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

  Widget buildSheet(BuildContext context) {
    if (selectedEvents[selectedDay] != null) {
      var year = selectedDay.year;
      int month = selectedDay.month;
      var day = selectedDay.day;
      var realMonth;
      var realDay;

      if (month < 10) {
        realMonth = "0" + month.toString();
      } else {
        realMonth = month;
      }

      if (day < 10) {
        realDay = "0" + day.toString();
      } else {
        realDay = day;
      }

      var earlySelectedDay = DateTime.parse(
          "$year-" + "$realMonth-" + "$realDay");
      String date = "$year-" + "$realMonth-" + "$realDay";

      selectedDay = earlySelectedDay;
      focusedDay = earlySelectedDay;

      if (startDt == "") {
        startDt = date;
        endDt = date;
      }

    } else {
      var year = selectedDay.year;
      int month = selectedDay.month;
      var day = selectedDay.day;
      var realMonth;
      var realDay;

      if (month < 10) {
        realMonth = "0" + month.toString();
      } else {
        realMonth = month;
      }

      if (day < 10) {
        realDay = "0" + day.toString();
      } else {
        realDay = day;
      }

      var earlySelectedDay = DateTime.parse(
          "$year-" + "$realMonth-" + "$realDay");
      String date = "$year-" + "$realMonth-" + "$realDay";

      selectedDay = earlySelectedDay;
      focusedDay = earlySelectedDay;

      if (startDt == "") {
        startDt = date;
        endDt = date;
      }
    }

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 1, 10, 10),
          child: Column(
              children: [
                Icon(
                  FontAwesomeIcons.gripLines,
                  color: Colors.black26,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                Text(
                  "커플 캘린더 일정 등록",
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: _eventController,
                  decoration: InputDecoration(
                    hintText: "일정 제목을 입력해주세요!",
                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                  ),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "시작 날짜",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        startDt,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          child: Text(
                            "수정",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onPressed: () {
                            startDtTemp = _stringToDate(startDt);
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)
                                  )
                                ),
                                context: context,
                                builder: (context) {
                                  return Container(
                                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      height: MediaQuery.of(context).size.height * 0.45,
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: CupertinoDatePicker(
                                              minimumYear: DateTime.now().year - 3,
                                              maximumYear: DateTime.now().year + 3,
                                              initialDateTime: DateTime.parse(startDt),
                                              onDateTimeChanged: (changed) {
                                                startDtTemp = changed;
                                              },
                                              mode: CupertinoDatePickerMode.date,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: TextButton(
                                              child: Text(
                                                "확인",
                                                style: Theme.of(context).textTheme.bodyText2,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  startDt = _dateToString("startDt");
                                                });
                                                Navigator.of(context).pop();
                                              },
                                            )
                                          )
                                        ],
                                      )
                                  );
                                }
                            );
                          },
                        )
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "종료 날짜",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        endDt,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: TextButton(
                          child: Text(
                            "수정",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onPressed: () {
                            endDtTemp = _stringToDate(endDt);
                            showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20.0)
                                  )
                                ),
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: MediaQuery.of(context).size.height * 0.45,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: CupertinoDatePicker(
                                            minimumYear: DateTime.now().year - 3,
                                            maximumYear: DateTime.now().year + 3,
                                            initialDateTime: DateTime.parse(endDt),
                                            onDateTimeChanged: (changed) {
                                              endDtTemp = changed;
                                            },
                                            mode: CupertinoDatePickerMode.date,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: TextButton(
                                            child: Text(
                                              "확인",
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                            onPressed: () {
                                              DateTime startDate = DateTime.parse(startDt);
                                              int difference = int.parse(endDtTemp.difference(startDate).inDays.toString());

                                              if (difference < 0) {
                                                dateSelectErrorAlert(context);
                                              } else {
                                                setState(() {
                                                  endDt = _dateToString("endDt");
                                                });
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          )
                                        )
                                      ],
                                    )
                                  );
                                }
                            );
                          },
                        )
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "색상 선택",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                GridView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: colorsData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10, childAspectRatio: MediaQuery.of(context).size.width / MediaQuery.of(context).size.height),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
                      child: Column(
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              setState(() {
                                selectedColor = index;
                              });
                            },
                            child: Icon(
                              Icons.done,
                              color: index == selectedColor ? Colors.white : Colors.transparent,
                              size: 20,
                            ),
                            backgroundColor: colorsData.elementAt(index),
                            elevation: 0.0,
                            heroTag: null,
                          ),
                        ],
                      ),
                    );
                  },
                  shrinkWrap: true,
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    icon: Padding(
                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.009, 0, 0, 0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    label: Padding(
                      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.003, MediaQuery.of(context).size.width * 0.003, 0),
                      child: Text(
                        "일정 추가",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    style: TextButton.styleFrom(
                        alignment: Alignment.center,
                        minimumSize: Size(MediaQuery.of(context).size.width * 0.30, MediaQuery.of(context).size.height * 0.05),
                        backgroundColor: const Color(0xffFE9BE6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        )
                    ),
                    onPressed: () async {
                      if (_eventController.text == "" || _eventController.text == " " || _eventController.text.isEmpty) {
                        return contentIsEmptyAlert(context);
                      } else {
                        DateTime startDtData = _stringToDate(startDt);
                        DateTime endDtData = _stringToDate(endDt);
                        List<DateTime> checkList = getDaysInBetween(startDtData, endDtData);

                        for (int i = 0; i < checkList.length; i++) {
                          if (selectedEvents[checkList[i]] != null && selectedEvents[checkList[i]]!.length >= 3) {
                            return calendarExceededErrorAlert(context);
                          }
                        }

                        Color selectColor = colorsData.elementAt(selectedColor);
                        String selectedColorString = "";
                        bool isPeriod = (startDt == endDt) ? false : true;

                        Glob.colorStringToColor.entries.firstWhere((element) {
                          if (element.value == selectColor) {
                            selectedColorString = element.key;
                            return true;
                          } else {
                            return false;
                          }
                        });

                        GlobalAlert().onLoading(context);
                        await _setCalendar(isPeriod, startDtData, endDtData, selectedColorString, _eventController.text);
                        await Future.delayed(Duration(seconds: 2));
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 3,)));
                      }
                    },
                  ),
                )
              ]
          ),
        );
      },
    );

  }


  _setCalendar(bool isPeriod, DateTime startDt, DateTime endDt, String color, String memo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/calendar');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "isPeriod": isPeriod,
      "startDt": startDt.toString(),
      "endDt": endDt.toString(),
      "color": color.toString(),
      "memo": memo
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );
  }

  _getCalendar() async {
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

    /// 초기화, 초기화를 하지 않으면 이 맵에 계속 + 되어서 쌓임
    _calendarData = {};

    for (int i = 0; i < calendarDto.length; i++) {
      /// 여기서는 무조건 1:N으로 넣어줘야함 그래야 해당 날짜를 클릭했을 때 메모 리스트를 볼 수 있음
      if (calendarDto[i].isPeriod) {
        DateTime startDt = DateTime.parse(calendarDto[i].startDt.toString());
        DateTime endDt = DateTime.parse(calendarDto[i].endDt.toString());

        List<DateTime> periodDateList = getDaysInBetween(startDt, endDt);

        // 중복된 날짜는 하나로 합쳐서 DateTime, List<String> 형태로 반환해야함
        for (int j = 0; j < periodDateList.length; j++) {
          if (_calendarData.containsKey(periodDateList[j])) {
            /// 중복인 경우
            _calendarData.keys.firstWhere((key) {
              if (key == periodDateList[j]) {
                List<String> valueList = _calendarData[key]!;
                valueList.add(calendarDto[i].memo.toString());
                _calendarData[key] = valueList;
                return true;
              } else {
                return false;
              }
            });
          } else {
            /// 중복이 아닌 경우
            List<String> valueList = [];
            valueList.add(calendarDto[i].memo.toString());
            Map<DateTime, List<String>> resultTemp = {periodDateList[j] : valueList};
            _calendarData.addAll(resultTemp);
          }
        }
      } else {
        if (_calendarData.containsKey(DateTime.parse(calendarDto[i].startDt.toString()))) {
          _calendarData.keys.firstWhere((key) {
            if (key == DateTime.parse(calendarDto[i].startDt.toString())) {
              List<String> valueList = _calendarData[key]!;
              valueList.add(calendarDto[i].memo.toString());
              _calendarData[key] = valueList;
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
    }
    _fetchData = _calendarData;
    calendarDtoList = calendarDto;

    return calendarDto;

  }

  _deleteCalendar(int calendarSeq, DateTime startDt, DateTime endDt, String memo) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);
    var coupleCode = pref.getString(Glob.coupleCode);

    var url = Uri.parse(Glob.memberUrl + '/delete/calendar');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "calendarSeq": calendarSeq,
      "coupleCode": coupleCode.toString(),
      "startDt": startDt.toString(),
      "endDt": endDt.toString(),
      "memo": memo
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    return jsonDecode(response.body);
  }

  contentIsEmptyAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "미입력 오류",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '일정을 입력해주세요!',
        style: Theme.of(context).textTheme.bodyText2,
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

  _dateToString(String dateTemp) {
    if (dateTemp == "startDt") {
      var year = startDtTemp.year;
      int month = startDtTemp.month;
      var day = startDtTemp.day;
      var realMonth;
      var realDay;

      if (month < 10) {
        realMonth = "0" + month.toString();
      } else {
        realMonth = month;
      }

      if (day < 10) {
        realDay = "0" + day.toString();
      } else {
        realDay = day;
      }
      String date = "$year-" + "$realMonth-" + "$realDay";

      return date;
    } else {
      var year = endDtTemp.year;
      int month = endDtTemp.month;
      var day = endDtTemp.day;
      var realMonth;
      var realDay;

      if (month < 10) {
        realMonth = "0" + month.toString();
      } else {
        realMonth = month;
      }

      if (day < 10) {
        realDay = "0" + day.toString();
      } else {
        realDay = day;
      }
      String date = "$year-" + "$realMonth-" + "$realDay";

      return date;
    }
  }

  _stringToDate(String date) {
    var year = DateTime.parse(date).year;
    int month = DateTime.parse(date).month;
    var day = DateTime.parse(date).day;
    var realMonth;
    var realDay;

    if (month < 10) {
      realMonth = "0" + month.toString();
    } else {
      realMonth = month;
    }

    if (day < 10) {
      realDay = "0" + day.toString();
    } else {
      realDay = day;
    }
    return DateTime.parse("$year-" + "$realMonth-" + "$realDay" + " 00:00:00.000Z");
  }

  dateSelectErrorAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "선택 불가",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '종료 날짜는 시작 날짜보다 \n작을 수 없습니다!',
        style: Theme.of(context).textTheme.bodyText2,
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

  calendarExceededErrorAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "등록 불가",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '선택한 기간중에 일정이 \n3개 초과인 날짜가 있습니다!',
        style: Theme.of(context).textTheme.bodyText2,
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
