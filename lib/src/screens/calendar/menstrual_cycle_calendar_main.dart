import 'package:couple_signal/src/models/calendar/menstrual_cycle_calendar_dto.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle_dto.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_faq.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_calendar.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_info.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_setting.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/menstrual_cycle.dart';

class MenstrualCycleCalendarMain extends StatefulWidget {
  final MenstrualCycleDto menstrualCycleDto;
  const MenstrualCycleCalendarMain({required this.menstrualCycleDto, Key? key}) : super(key: key);

  @override
  State<MenstrualCycleCalendarMain> createState() => _MenstrualCycleCalendarMainState();
}

class _MenstrualCycleCalendarMainState extends State<MenstrualCycleCalendarMain> {
  String today = DateTime.now().year.toString() + "년 " + DateTime.now().month.toString() + "월 " + DateTime.now().day.toString() + "일";
  @override
  Widget build(BuildContext context) {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "생리주기 캘린더",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Container(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Card(
                            elevation: 0.0,
                            child: Container(
                              color: const Color(0xffFFF1F5),
                              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Stack(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: TextButton(
                                            child: Text(
                                              today,
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: TextButton.icon(
                                            icon: Icon(
                                              Icons.settings,
                                              color: Colors.black,
                                            ),
                                            label: Padding(
                                              padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                                              child: Text(
                                                "설정",
                                                style: Theme.of(context).textTheme.bodyText2,
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            onPressed: () async {
                                              MenstrualCycleDto menstrualCycleDto = await _menstrualCycle.getMenstrualCycleData();

                                              bool permissionCheck = await _menstrualCycle.permissionCheck();

                                              if (permissionCheck == true) {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleSetting()));
                                              } else {
                                                noPermissionAlert(context);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: (this.widget.menstrualCycleDto.lastMenstrualStartDt != "" && this.widget.menstrualCycleDto.menstrualCycle != 0 && this.widget.menstrualCycleDto.menstrualPeriod != 0) ?
                                        FutureBuilder(
                                          future: _menstrualCycle.getMenstrualCycleCalendar(),
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: const CircularProgressIndicator(),
                                              );
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                '잠시 후 다시 시도해주세요!',
                                                style: Theme.of(context).textTheme.bodyText2,
                                              );
                                            } else if (snapshot.data == false) {
                                              return Text("잠시 후 다시 시도해주세요!");
                                            } else {
                                              MenstrualCycleCalendarDto dto = snapshot.data;

                                              if (dto.isValid == false) {
                                                return Text(
                                                  "생리주기 설정이 필요해요!",
                                                  style: Theme.of(context).textTheme.bodyText1,
                                                );
                                              } else {
                                                var _toDay = DateTime.now();
                                                var _date = DateTime(_toDay.year, _toDay.month, _toDay.day);
                                                String menstrualDt = dto.menstrualCycleStartDt.toString();

                                                List<DateTime> beforeDateList = getDaysInBetween(DateTime.parse(dto.beforeMenstrualCycleStartDt.toString()), DateTime.parse(dto.beforeMenstrualCycleEndDt.toString()));
                                                List<DateTime> dateList = getDaysInBetween(DateTime.parse(dto.menstrualCycleStartDt.toString()), DateTime.parse(dto.menstrualCycleEndDt.toString()));
                                                List<DateTime> afterDateList = getDaysInBetween(DateTime.parse(dto.afterMenstrualCycleStartDt.toString()), DateTime.parse(dto.afterMenstrualCycleEndDt.toString()));

                                                String year = DateTime.now().year.toString();
                                                String month = int.parse(DateTime.now().month.toString()) < 10 ? "0"+ DateTime.now().month.toString() : DateTime.now().month.toString();
                                                String day = int.parse(DateTime.now().day.toString()) < 10 ? "0"+ DateTime.now().day.toString() : DateTime.now().day.toString();

                                                DateTime now = DateTime.parse(year + "-" + month + "-" + day + " 00:00:00.000Z");

                                                if (beforeDateList.contains(now) || dateList.contains(now) || afterDateList.contains(now)) {
                                                  return RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '오늘은 ',
                                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                                        ),
                                                        TextSpan(
                                                          text: '생리 예정일이에요',
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                      ]
                                                    ),
                                                  );
                                                } else {
                                                  int difference = int.parse(DateTime.parse(dto.beforeMenstrualCycleStartDt.toString()).difference(_date).inDays.toString());

                                                  if (difference < 0) {
                                                    difference = int.parse(DateTime.parse(menstrualDt).difference(_date).inDays.toString());
                                                    if (difference < 0) {
                                                      difference = int.parse(DateTime.parse(dto.afterMenstrualCycleStartDt.toString()).difference(_date).inDays.toString());
                                                    }
                                                  }
                                                  return RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: '$difference일 ',
                                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                                        ),
                                                        TextSpan(
                                                          text: '후 생리 예정이에요',
                                                          style: Theme.of(context).textTheme.bodyText1,
                                                        ),
                                                      ]
                                                    ),
                                                  );
                                                }
                                              }
                                            }
                                          }
                                        ) :
                                        Text(
                                          "생리주기 설정이 필요해요!",
                                          style: Theme.of(context).textTheme.bodyText1,
                                        )
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: TextButton(
                                      child: Text(
                                        "캘린더 보기",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color(0xffFE9BE6),
                                        minimumSize: Size(MediaQuery.of(context).size.width * 0.65, MediaQuery.of(context).size.height * 0.02)
                                        // padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.65, vertical: MediaQuery.of(context).size.height * 0.02)
                                      ),
                                      onPressed: () async {
                                        await _menstrualCycle.getMenstrualCycleData();

                                        if (_menstrualCycle.getMenstrualCycleSeq == 0 || _menstrualCycle.getLastMenstrualStartDt == "" || _menstrualCycle.getMenstrualCycle == 0 || _menstrualCycle.getMenstrualPeriod == 0) {
                                          calendarErrorAlert(context);
                                        } else {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleCalendar()));
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            )
                        ),
                      ),
                    )
                  ],
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Text(
                                  "생리에 대해 얼마나 알고 계신가요?",
                                  style: Theme.of(context).textTheme.bodyText1
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '#생리',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey.shade600),
                                      ),
                                      TextSpan(
                                        text: '  #배란',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey.shade600),
                                      ),
                                      TextSpan(
                                        text: '  #가임기',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey.shade600),
                                      ),
                                      TextSpan(
                                        text: '  #피임약',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey.shade600),
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Text(
                                  "터치하여 알아보기",
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                )
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleInfo()));
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(
                                "하트널의 생리주기 FAQ",
                                style: Theme.of(context).textTheme.bodyText1
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(
                                "터치하여 알아보기",
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                              )
                            ),
                          ],
                        ),
                      )
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleFAQ()));
                  },
                ),
                InkWell(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    child: Card(
                      elevation: 4.0,
                      child: InkWell(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '준비중입니다!',
                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24, color: Colors.grey),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.grey,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                              child: Text(
                                                '조금만 기다려주세요.',
                                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            children: [
                                              IconButton(
                                                padding: const EdgeInsets.fromLTRB(0, 0, 60, 55),
                                                onPressed: () {
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                                                },
                                                icon: Icon(
                                                  FontAwesomeIcons.hourglassHalf,
                                                  color: Colors.grey,
                                                  size: 70,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        onTap: () {},
                      )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  calendarErrorAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "데이터 부족",
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
        '충분한 데이터를 입력해주세요!\n아래의 필수 데이터를 확인해주세요!\n최근 생리 예정일, 생리 주기, 생리 기간',
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
}
