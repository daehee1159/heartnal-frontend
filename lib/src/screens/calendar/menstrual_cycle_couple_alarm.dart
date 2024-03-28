import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/menstrual_cycle.dart';

class MenstrualCycleCoupleAlarm extends StatefulWidget {
  const MenstrualCycleCoupleAlarm({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleCoupleAlarm> createState() => _MenstrualCycleCoupleAlarmState();
}

class _MenstrualCycleCoupleAlarmState extends State<MenstrualCycleCoupleAlarm> {
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editingController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "생리주기 커플 알림 설정",
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
                  "알림 설정",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "생리 예정 3일전",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getMenstruation3DaysAgoToCoupleAlarm == "" || _menstrualCycle.getMenstruation3DaysAgoToCoupleAlarm == "N") ? "OFF" : "ON",
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
                _alarmAlert(context, "생리 예정 3일전");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "생리 예정일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getMenstruationDtToCoupleAlarm == "" || _menstrualCycle.getMenstruationDtToCoupleAlarm == "N") ? "OFF" : "ON",
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
                _alarmAlert(context, "생리 예정일");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "배란 예정일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getOvulationDtToCoupleAlarm == "" || _menstrualCycle.getOvulationDtToCoupleAlarm == "N") ? "OFF" : "ON",
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
                _alarmAlert(context, "배란 예정일");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "가임기 시작일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getFertileWindowStartDtToCoupleAlarm == "" || _menstrualCycle.getFertileWindowStartDtToCoupleAlarm == "N") ? "OFF" : "ON",
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
                _alarmAlert(context, "가임기 시작일");
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.map),
              title: Text(
                "가임기 종료일",
                style: Theme.of(context).textTheme.bodyText2,
              ),
              trailing: Wrap(
                spacing: 13,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Text(
                      (_menstrualCycle.getFertileWindowsEndDtToCoupleAlarm == "" || _menstrualCycle.getFertileWindowsEndDtToCoupleAlarm == "N") ? "OFF" : "ON",
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
                _alarmAlert(context, "가임기 종료일");
              },
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  // 알람 Alert
  _alarmAlert(BuildContext context, String category) async {
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);
    String selectedValue = "기본 문구";
    bool switchValue = false;
    String alarmCategory = "";
    String contentText = "";
    String sendCategory = "";

    switch (category) {
      case "생리 예정 3일전":
        alarmCategory = "menstruation3DaysAgoAlarm";
        contentText = (_menstrualCycle.getMenstruation3DaysAgoToCouple == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 생리 예정 3일전이에요.") ? "오늘은 생리 예정 3일전이에요." : _menstrualCycle.getMenstruation3DaysAgoToCouple;
        sendCategory = "menstruation3DaysAgo";
        switchValue = (_menstrualCycle.getMenstruation3DaysAgoToCoupleAlarm == "" || _menstrualCycle.getMenstruation3DaysAgoToCoupleAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getMenstruation3DaysAgoToCouple == "오늘은 생리 예정 3일전이에요." || _menstrualCycle.getMenstruation3DaysAgoToCouple == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getMenstruation3DaysAgoToCouple == "오늘은 생리 예정 3일전이에요.") ? "" : _menstrualCycle.getMenstruation3DaysAgoToCouple;
        break;
      case "생리 예정일":
        alarmCategory = "menstruationDtAlarm";
        contentText = (_menstrualCycle.getMenstruationDtToCouple == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 생리 예정일이에요.") ? "오늘은 생리 예정일이에요." : _menstrualCycle.getMenstruationDtToCouple;
        sendCategory = "menstruationDt";
        switchValue = (_menstrualCycle.getMenstruationDtToCoupleAlarm == "" || _menstrualCycle.getMenstruationDtToCoupleAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getMenstruationDtToCouple == "오늘은 생리 예정일이에요." || _menstrualCycle.getMenstruationDtToCouple == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getMenstruationDtToCouple == "오늘은 생리 예정일이에요.") ? "" : _menstrualCycle.getMenstruationDtToCouple;
        break;
      case "배란 예정일":
        alarmCategory = "ovulationDtAlarm";
        contentText = (_menstrualCycle.getOvulationDtToCouple == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 배란 예정일이에요.") ? "오늘은 배란 예정일이에요." : _menstrualCycle.getOvulationDtToCouple;
        sendCategory = "ovulationDt";
        switchValue = (_menstrualCycle.getOvulationDtToCoupleAlarm == "" || _menstrualCycle.getOvulationDtToCoupleAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getOvulationDtToCouple == "오늘은 배란 예정일이에요." || _menstrualCycle.getOvulationDtToCouple == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getOvulationDtToCouple == "오늘은 배란 예정일이에요.") ? "" : _menstrualCycle.getOvulationDtToCouple;
        break;
      case "가임기 시작일":
        alarmCategory = "fertileWindowStartDtAlarm";
        contentText = (_menstrualCycle.getFertileWindowStartDtToCouple == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 가임기 시작일이에요.") ? "오늘은 가임기 시작일이에요." : _menstrualCycle.getFertileWindowStartDtToCouple;
        sendCategory = "fertileWindowStartDt";
        switchValue = (_menstrualCycle.getFertileWindowStartDtToCoupleAlarm == "" || _menstrualCycle.getFertileWindowStartDtToCoupleAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getFertileWindowStartDtToCouple == "오늘은 가임기 시작일이에요." || _menstrualCycle.getFertileWindowStartDtToCouple == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getFertileWindowStartDtToCouple == "오늘은 가임기 시작일이에요.") ? "" : _menstrualCycle.getFertileWindowStartDtToCouple;
        break;
      case "가임기 종료일":
        alarmCategory = "fertileWindowsEndDtAlarm";
        contentText = (_menstrualCycle.getFertileWindowsEndDtToCouple == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 가임기 마지막날이에요.") ? "오늘은 가임기 마지막날이에요." : _menstrualCycle.getFertileWindowsEndDtToCouple;
        sendCategory = "fertileWindowsEndDt";
        switchValue = (_menstrualCycle.getFertileWindowsEndDtToCoupleAlarm == "" || _menstrualCycle.getFertileWindowsEndDtToCoupleAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getFertileWindowsEndDtToCouple == "오늘은 가임기 마지막날이에요." || _menstrualCycle.getFertileWindowsEndDtToCouple == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getFertileWindowsEndDtToCouple == "오늘은 가임기 마지막날이에요.") ? "" : _menstrualCycle.getFertileWindowsEndDtToCouple;
        break;
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
                        category,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "알림 설정",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 10.0,
                              child: CupertinoSwitch(
                                value: switchValue,
                                activeColor: const Color(0xffFE9BE6),
                                onChanged: (value) {
                                  dialogSetState(() {
                                    switchValue = value;
                                  });
                                },
                              ),
                            )
                          ],
                        ),
                        Divider(),
                        Container(
                          color: Color(0xffF3F3F3),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(17, 10, 10, 10),
                            child: Center(
                              child: Text(
                                "알림 문구",
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Radio(
                                            value: "기본 문구",
                                            groupValue: selectedValue,
                                            onChanged: (value) {
                                              dialogSetState(() {
                                                selectedValue = "기본 문구";
                                                FocusScope.of(context).unfocus();
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "기본 문구",
                                        style: Theme.of(context).textTheme.bodyText2,
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  dialogSetState(() {
                                    selectedValue = "기본 문구";
                                    FocusScope.of(context).unfocus();
                                  });
                                },
                              ),
                              Text(
                                contentText,
                                style: Theme.of(context).textTheme.bodyText2,
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: Radio(
                                        value: "직접 입력",
                                        groupValue: selectedValue,
                                        onChanged: (value) {
                                          dialogSetState(() {
                                            selectedValue = "직접 입력";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "직접 입력",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  )
                                ],
                              ),
                              onTap: () {
                                dialogSetState(() {
                                  selectedValue = "직접 입력";
                                });
                              },
                            ),
                            TextField(
                              controller: _editingController,
                              style: const TextStyle(color: Colors.black),
                              keyboardType: TextInputType.text,
                              maxLength: 20,
                              onTap: () {
                                setState(() {
                                  selectedValue = "직접 입력";
                                });
                              },
                            ),
                          ],
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
                        _editingController.clear();
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        '확인',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
                      ),
                      onPressed: () async {
                        /// selectedValue 가 기본 문구 인지 직접 입력 인지에 따라 로직을 다르게 설정해야함
                        if (selectedValue == "기본 문구") {
                          // 기본문구일때는 contentText 를 그냥 가져오면 됨
                          bool result = await _menstrualCycle.setMenstrualCycleMessage(alarmCategory, (switchValue == true) ? "Y" : "N", sendCategory, contentText, "coupleData");

                          if (result == true) {
                            switch (category) {
                              case "생리 예정 3일전":
                                _menstrualCycle.setMenstruation3DaysAgoToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruation3DaysAgoToCouple = "오늘은 생리 예정 3일전이에요.";
                                break;
                              case "생리 예정일":
                                _menstrualCycle.setMenstruationDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruationDtToCouple = "오늘은 생일 예정일이에요.";
                                break;
                              case "배란 예정일":
                                _menstrualCycle.setOvulationDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setOvulationDtToCouple = "오늘은 배란 예정일이에요.";
                                break;
                              case "가임기 시작일":
                                _menstrualCycle.setFertileWindowStartDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowStartDtToCouple = "오늘부터 가임기 시작이에요.";
                                break;
                              case "가임기 종료일":
                                _menstrualCycle.setFertileWindowsEndDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowsEndDtToCouple = "오늘은 가임기 마지막날이에요.";
                                break;
                            }
                            await _saveSuccessAlert(context);
                            setState(() {

                            });
                          } else {
                            _failureAlert(context);
                          }
                        } else {
                          // 직접 입력일때는 _editingController 의 text 를 가져오면 됨
                          bool result = await _menstrualCycle.setMenstrualCycleMessage(alarmCategory, (switchValue == true) ? "Y" : "N", sendCategory, _editingController.text, "coupleData");

                          if (result == true) {
                            switch (category) {
                              case "생리 예정 3일전":
                                _menstrualCycle.setMenstruation3DaysAgoToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruation3DaysAgoToCouple = _editingController.text;
                                break;
                              case "생리 예정일":
                                _menstrualCycle.setMenstruationDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruationDtToCouple = _editingController.text;
                                break;
                              case "배란 예정일":
                                _menstrualCycle.setOvulationDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setOvulationDtToCouple = _editingController.text;
                                break;
                              case "가임기 시작일":
                                _menstrualCycle.setFertileWindowStartDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowStartDtToCouple = _editingController.text;
                                break;
                              case "가임기 종료일":
                                _menstrualCycle.setFertileWindowsEndDtToCoupleAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowsEndDtToCouple = _editingController.text;
                                break;
                            }
                            _saveSuccessAlert(context);
                          } else {
                            _failureAlert(context);
                          }
                        }
                        _editingController.clear();
                      },
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  _saveSuccessAlert(BuildContext context) async {
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
            setState(() {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            });
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
    MenstrualCycle _menstrualCycle = Provider.of<MenstrualCycle>(context, listen: false);

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
