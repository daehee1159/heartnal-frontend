import 'dart:ui';

import 'package:couple_signal/src/models/calendar/menstrual_cycle_dto.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/screens/calendar/couple_calendar.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_calendar_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/menstrual_cycle.dart';

class TabBarFourth extends StatefulWidget {
  const TabBarFourth({Key? key}) : super(key: key);

  @override
  State<TabBarFourth> createState() => _TabBarFourthState();
}

class _TabBarFourthState extends State<TabBarFourth> {
  bool isSized1700 = window.physicalSize.height > 1700;
  @override
  Widget build(BuildContext context) {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                          elevation: 4.0,
                          child: Container(
                            color: const Color(0xffFFF1F5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '하트널',
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                          ),
                                          TextSpan(
                                            text: '의 다양한 ',
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                          TextSpan(
                                            text: '공용 캘린더',
                                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                          ),
                                          TextSpan(
                                            text: '를',
                                            style: Theme.of(context).textTheme.bodyText1,
                                          ),
                                        ]
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "이용해보세요!",
                                    style: Theme.of(context).textTheme.bodyText1,
                                  )
                                ),
                              ],
                            ),
                          )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
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
                                                      '커플공용 캘린더',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '이미지를 클릭해보세요.',
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
                                                      onPressed: () async {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => CoupleCalendar()));
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.8,
                                                        height: MediaQuery.of(context).size.height * 0.2,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.2,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                                                          minWidth: MediaQuery.of(context).size.width * 0.8,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.8,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_calendar.json',
                                                            width: MediaQuery.of(context).size.width * 0.8,
                                                            height: MediaQuery.of(context).size.height * 0.2,
                                                          ),
                                                        ),
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
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CoupleCalendar()));
                            },
                          )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
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
                                                      '생리주기 캘린더',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '이미지를 클릭해보세요.',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                  ),
                                                ),
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
                                                      padding: const EdgeInsets.fromLTRB(0, 30, 10, 55),
                                                      onPressed: () async {
                                                        MenstrualCycleDto menstrualCycleDto = await _menstrualCycle.getMenstrualCycleData();

                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleCalendarMain(menstrualCycleDto: menstrualCycleDto,)));
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.55,
                                                        height: MediaQuery.of(context).size.height * 0.2,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.2,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                                                          minWidth: MediaQuery.of(context).size.width * 0.55,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.55,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_menstrual_calendar.json',
                                                            width: MediaQuery.of(context).size.width * 0.55,
                                                            height: MediaQuery.of(context).size.height * 0.2,
                                                          ),
                                                        ),
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
                            onTap: () async {
                              MenstrualCycleDto menstrualCycleDto = await _menstrualCycle.getMenstrualCycleData();

                              Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleCalendarMain(menstrualCycleDto: menstrualCycleDto,)));
                            },
                          )
                      ),
                    ),
                    /// 여기서 cached_network_image library 테스트 해봐야함
                    /// 일반 storage service getDownLoadUrl 을 통해 불러온 이미지와, CachedNetworkImage 를 통해 불러온 이미지의 업로드 속도 차이가 많이 난다면 이걸로 바꿔야함
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
