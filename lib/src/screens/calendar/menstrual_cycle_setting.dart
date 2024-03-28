import 'package:couple_signal/src/models/calendar/menstrual_cycle_dto.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/calendar/menstrual_cycle_couple_alarm.dart';
import 'package:couple_signal/src/screens/calendar/mestrual_cycle_my_alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/menstrual_cycle.dart';
import '../../models/theme/theme_provider.dart';

class MenstrualCycleSetting extends StatefulWidget {
  const MenstrualCycleSetting({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleSetting> createState() => _MenstrualCycleSettingState();
}

class _MenstrualCycleSettingState extends State<MenstrualCycleSetting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "생리주기 설정",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: Container(
        child: ListView(
          children: [
            Container(
              color: Color(0xffF3F3F3),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 10, 10),
                child: Text(
                  "생리주기",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "마지막 생리 시작일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      _menstrualCycle.getLastMenstrualStartDt == "" ? "날짜 미선택" : _menstrualCycle.getLastMenstrualStartDt.substring(0,10),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () async {
                DateTime currentDate = DateTime.now();
                bool isCanceled = true;

                ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                Future<void> _selectDate(BuildContext context) async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    locale: Locale('ko'),
                    helpText: "",
                    firstDate: DateTime(currentDate.year - 1),
                    lastDate: DateTime(currentDate.year + 1),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: _themeProvider.themeData(_themeProvider.darkTheme).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color(0xffFE9BE6),
                            onPrimary: Colors.white,
                          ),
                          dialogBackgroundColor:Colors.white,
                        ),
                        child: child as Widget,
                      );
                    },
                  );
                  /// (pickedDate == null) = 취소 버튼 누름
                  if (pickedDate == null) {
                    isCanceled = false;
                  } else {
                    _menstrualCycle.setLastMenstrualStartDt = pickedDate.toString().substring(0, 10);
                    /// 여기서 API 호출 해야함
                    bool result = await _menstrualCycle.setMenstrualCycleData("lastMenstrualStartDt", _menstrualCycle.getLastMenstrualStartDt);

                    if (result == true) {
                      setState(() {
                        _saveSuccessAlert(context, false);
                      });
                    } else {
                      _failureAlert(context);
                    }
                  }
                }
                await _selectDate(context);
                if (isCanceled) {
                  setState(() {

                  });
                }
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "생리주기 설정",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getMenstrualCycle == 0) ? "미설정" : "평균 " + _menstrualCycle.getMenstrualCycle.toString() + "일",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () {
                _menstrualCycleSettingAlert(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "생리기간 설정",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getMenstrualPeriod == 0) ? "미설정" : "평균 " + _menstrualCycle.getMenstrualPeriod.toString() + "일",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () async {
                await _menstrualPeriodSettingAlert(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "피임약 복용 여부",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getContraceptiveYN == "Y") ? "복용중" : "미복용",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () {
                _contraceptiveSettingAlert(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "피임약 복용 시작일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      _menstrualCycle.getTakingContraceptiveDt == "" ? "날짜 미선택" : _menstrualCycle.getTakingContraceptiveDt.substring(0, 10),
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () async {
                /// 여기는 피임약 복용 여부가 선택되어 있지 않으면 피임약 복용 여부를 먼저 선택해달라는 alert 를 띄워야함
                if (_menstrualCycle.getContraceptiveYN == "N") {
                  // alert
                  _contraceptiveAlert(context);
                } else {
                  DateTime currentDate = DateTime.now();
                  bool isCanceled = true;

                  ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                  Future<void> _selectDate(BuildContext context) async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: currentDate,
                      locale: Locale('ko'),
                      helpText: "",
                      firstDate: DateTime(currentDate.year - 1),
                      lastDate: DateTime(currentDate.year + 1),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: _themeProvider.themeData(_themeProvider.darkTheme).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: Color(0xffFE9BE6),
                              onPrimary: Colors.white,
                            ),
                            dialogBackgroundColor:Colors.white,
                          ),
                          child: child as Widget,
                        );
                      },
                    );
                    /// (pickedDate == null) = 취소 버튼 누름
                    if (pickedDate == null) {
                      isCanceled = false;
                    } else {
                      _menstrualCycle.setTakingContraceptiveDt = pickedDate.toString().substring(0, 10);
                      /// 여기서 API 호출 해야함
                      bool result = await _menstrualCycle.setMenstrualCycleData("takingContraceptiveDt", _menstrualCycle.getTakingContraceptiveDt);

                      if (result == true) {
                        _saveSuccessAlert(context, false);
                      } else {
                        _failureAlert(context);
                      }
                    }
                  }
                  await _selectDate(context);
                  if (isCanceled) {
                    setState(() {

                    });
                  }
                }
              },
            ),
            Container(
              color: Color(0xffF3F3F3),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 10, 10),
                child: Text(
                  "알림",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "나에게 알림",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      "",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () async {
                await _menstrualCycle.getMenstrualCycleMessage();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleMyAlarm()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "상대방에게 알림",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      "",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () async {
                await _menstrualCycle.getMenstrualCycleCoupleMessage();
                Navigator.push(context, MaterialPageRoute(builder: (context) => MenstrualCycleCoupleAlarm()));
              },
            ),
            Container(
              color: Color(0xffF3F3F3),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(17, 10, 10, 10),
                child: Text(
                  "설정",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "설정 초기화",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      "",
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6), fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  )
                ],
              ),
              onTap: () {
                _menstrualCycleInitAlert(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // 생리주기 설정 Alert
  _menstrualCycleSettingAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    List<int> item = Glob.menstrualCycleList;
    int selectedItem = 28;

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "생리주기 설정",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.heartPulse,
          color: const Color(0xffFE9BE6),
        ),
        onPressed: () {},
      ),
      content: Container(
        height: 150,
        child: CupertinoPicker(
          itemExtent: 40,
          scrollController: FixedExtentScrollController(initialItem: (_menstrualCycle.getMenstrualCycle == 0) ? 14 : item.indexOf(_menstrualCycle.getMenstrualCycle)),
          onSelectedItemChanged: (index) async {
            setState(() {
              selectedItem = item[index];
            });
          },
          children: [
            ...item.map((e) => Center(
              child: Text(
                e.toString()
              ),
            ))
          ]
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () async {
            bool result = await _menstrualCycle.setMenstrualCycleData("menstrualCycle", selectedItem);
            Navigator.of(context).pop();
            if (result == true) {
              _menstrualCycle.setMenstrualCycle = selectedItem;
              await _saveSuccessAlert(context ,false);
              setState(() {

              });
            } else {
              _failureAlert(context);
            }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  // 생리기간 설정
  _menstrualPeriodSettingAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    List<int> item = Glob.menstrualPeriodList;
    int selectedItem = 5;

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "생리기간 설정",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.heartPulse,
          color: const Color(0xffFE9BE6),
        ),
        onPressed: () {},
      ),
      content: Container(
        height: 150,
        child: CupertinoPicker(
          itemExtent: 40,
          scrollController: FixedExtentScrollController(initialItem: (_menstrualCycle.getMenstrualPeriod == 0) ? 4 : item.indexOf(_menstrualCycle.getMenstrualPeriod)),
          onSelectedItemChanged: (index) async {
            setState(() {
              selectedItem = item[index];
            });
          },
          children: [
            ...item.map((e) => Center(
              child: Text(
                e.toString()
              ),
            ))
          ]
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () async {
            bool result = await _menstrualCycle.setMenstrualCycleData("menstrualPeriod", selectedItem);
            Navigator.of(context).pop();
            /// 이후 성공 실패 여부에 따른 alert
            if (result == true) {
              _menstrualCycle.setMenstrualPeriod = selectedItem;
              await _saveSuccessAlert(context, false);
              setState(() {

              });
            } else {
              _failureAlert(context);
            }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  // 피임약 설정
  _contraceptiveSettingAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    String selectedValue = Glob.contraceptiveList[4];

    if (_menstrualCycle.getContraceptive == "CONTRACEPTIVE_NONE") {
      selectedValue = Glob.contraceptiveList[4];
    } else {
      int index = Glob.contraceptiveList.indexOf(_menstrualCycle.getContraceptive);
      selectedValue = Glob.contraceptiveList[index];
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter dialogSetState) {
              return AlertDialog(
                title: TextButton.icon(
                  label: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      "피임약 복용 여부",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  icon: Icon(
                    FontAwesomeIcons.heartPulse,
                    color: const Color(0xffFE9BE6),
                  ),
                  onPressed: () {},
                ),
                content: Container(
                  // height: 150,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "피임약 설정 시 \n생리주기에 자동 반영돼요!",
                        style: Theme.of(context).textTheme.bodyText2,
                        textAlign: TextAlign.center,
                      ),
                      RadioListTile(
                        title: Text(
                          "21정 / 휴약기 7일",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        value: Glob.contraceptiveList[0],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedValue = Glob.contraceptiveList[0];
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          "21정 / 위약 7정",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        value: Glob.contraceptiveList[1],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedValue = Glob.contraceptiveList[1];
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          "24정 / 위약 4정",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        value: Glob.contraceptiveList[2],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedValue = Glob.contraceptiveList[2];
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          "26정 / 위약 2정",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        value: Glob.contraceptiveList[3],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedValue = Glob.contraceptiveList[3];
                          });
                        },
                      ),
                      RadioListTile(
                        title: Text(
                          "미설정",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        value: Glob.contraceptiveList[4],
                        groupValue: selectedValue,
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedValue = Glob.contraceptiveList[4];
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text(
                      '취소',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      '확인',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
                    ),
                    onPressed: () async {
                      bool result = await _menstrualCycle.setMenstrualCycleData("contraceptive", selectedValue);

                      if (result == true) {
                        if (selectedValue == "CONTRACEPTIVE_NONE") {
                          _menstrualCycle.setContraceptiveYN = "N";
                          _menstrualCycle.setContraceptive = selectedValue;
                        } else {
                          _menstrualCycle.setContraceptiveYN = "Y";
                          _menstrualCycle.setContraceptive = selectedValue;
                        }
                        await _saveSuccessAlert(context, true);
                        setState(() {

                        });

                      } else {
                        _failureAlert(context);
                      }
                      setState(() {

                      });
                    },
                  ),
                ],
              );
            }
          );
        }
    );
  }

  _menstrualCycleInitAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "생리주기 초기화",
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
        "생리주기 데이터 초기화 후에는\n복구가 불가능해요!\n초기화를 진행할까요?",
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () async {
            MenstrualCycleDto menstrualCycleData = await _menstrualCycle.getMenstrualCycleData();

            if (menstrualCycleData.menstrualCycleSeq == 0 || menstrualCycleData.menstrualCycleSeq == null) {
              _noDataAlert(context);
            } else {
              /// 권한 체크 필요
              bool permissionCheck = await _menstrualCycle.permissionCheck();

              if (permissionCheck == true) {
                bool result = await _menstrualCycle.initMenstrualCycle();
                if (result == true) {
                  _menstrualCycle.initProvider();
                  _initSuccessAlert(context);
                  setState(() {

                  });
                } else {
                  _initFailureAlert(context);
                }
              } else {
                _noPermissionAlert(context);
              }
            }
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      }
    );
  }

  _saveSuccessAlert(BuildContext context, bool isStatefulBuilder) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "저장 성공",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '저장에 성공했어요.',
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
            /// statefulBuilder 를 통해 만들어진 alert 가 이쪽으로 넘어와서 pop() 을 하면 null value 오류 발생으로 어쩔수없이 이렇게함
            if (isStatefulBuilder == true) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pop();
            }
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

  _initSuccessAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "초기화 성공",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '초기화에 성공했어요.',
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
            Navigator.of(context).pop();
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

  _failureAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "저장 실패",
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
        "저장에 실패했어요\n 잠시 후 다시 시도해주세요!",
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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

  _contraceptiveAlert(BuildContext context) async {
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
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        "피임약 복용 여부를 먼저 선택해주세요!",
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

  _noDataAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "초기화 실패",
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
        "초기화할 데이터가 없어요!",
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
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

  _initFailureAlert(BuildContext context) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "초기화 실패",
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
        "초기화에 실패했어요\n 잠시 후 다시 시도해주세요!",
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () {
            Navigator.of(context).pop();
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

  _noPermissionAlert(BuildContext context) async {
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
