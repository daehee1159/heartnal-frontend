import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../models/calendar/menstrual_cycle.dart';

class MenstrualCycleMyAlarm extends StatefulWidget {
  const MenstrualCycleMyAlarm({Key? key}) : super(key: key);

  @override
  State<MenstrualCycleMyAlarm> createState() => _MenstrualCycleMyAlarmState();
}

class _MenstrualCycleMyAlarmState extends State<MenstrualCycleMyAlarm> {
  TextEditingController _editingController = TextEditingController();

  @override
  void initState() {
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
          "생리주기 알림 설정",
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
                      (_menstrualCycle.getMenstruation3DaysAgoAlarm == "" || _menstrualCycle.getMenstruation3DaysAgoAlarm == "N") ? "OFF" : "ON",
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
                      (_menstrualCycle.getMenstruationDtAlarm == "" || _menstrualCycle.getMenstruationDtAlarm == "N") ? "OFF" : "ON",
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
                      (_menstrualCycle.getOvulationDtAlarm == "" || _menstrualCycle.getOvulationDtAlarm == "N") ? "OFF" : "ON",
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
                      (_menstrualCycle.getFertileWindowStartDtAlarm == "" || _menstrualCycle.getFertileWindowStartDtAlarm == "N") ? "OFF" : "ON",
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
                      (_menstrualCycle.getFertileWindowsEndDtAlarm == "" || _menstrualCycle.getFertileWindowsEndDtAlarm == "N") ? "OFF" : "ON",
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
        contentText = (_menstrualCycle.getMenstruation3DaysAgo == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 생리 예정 3일전이에요.") ? "오늘은 생리 예정 3일전이에요." : _menstrualCycle.getMenstruation3DaysAgo;
        sendCategory = "menstruation3DaysAgo";
        switchValue = (_menstrualCycle.getMenstruation3DaysAgoAlarm == "" || _menstrualCycle.getMenstruation3DaysAgoAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getMenstruation3DaysAgo == "오늘은 생리 예정 3일전이에요." || _menstrualCycle.getMenstruation3DaysAgo == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getMenstruation3DaysAgo == "오늘은 생리 예정 3일전이에요.") ? "" : _menstrualCycle.getMenstruation3DaysAgo;
        break;
      case "생리 예정일":
        alarmCategory = "menstruationDtAlarm";
        contentText = (_menstrualCycle.getMenstruationDt == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 생리 예정일이에요.") ? "오늘은 생리 예정일이에요." : _menstrualCycle.getMenstruationDt;
        sendCategory = "menstruationDt";
        switchValue = (_menstrualCycle.getMenstruationDtAlarm == "" || _menstrualCycle.getMenstruationDtAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getMenstruationDt == "오늘은 생리 예정일이에요." || _menstrualCycle.getMenstruationDt == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getMenstruationDt == "오늘은 생리 예정일이에요.") ? "" : _menstrualCycle.getMenstruationDt;
        break;
      case "배란 예정일":
        alarmCategory = "ovulationDtAlarm";
        contentText = (_menstrualCycle.getOvulationDt == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 배란 예정일이에요.") ? "오늘은 배란 예정일이에요." : _menstrualCycle.getOvulationDt;
        sendCategory = "ovulationDt";
        switchValue = (_menstrualCycle.getOvulationDtAlarm == "" || _menstrualCycle.getOvulationDtAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getOvulationDt == "오늘은 배란 예정일이에요." || _menstrualCycle.getOvulationDt == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getOvulationDt == "오늘은 배란 예정일이에요.") ? "" : _menstrualCycle.getOvulationDt;
        break;
      case "가임기 시작일":
        alarmCategory = "fertileWindowStartDtAlarm";
        contentText = (_menstrualCycle.getFertileWindowStartDt == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 가임기 시작일이에요.") ? "오늘은 가임기 시작일이에요." : _menstrualCycle.getFertileWindowStartDt;
        sendCategory = "fertileWindowStartDt";
        switchValue = (_menstrualCycle.getFertileWindowStartDtAlarm == "" || _menstrualCycle.getFertileWindowStartDtAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getFertileWindowStartDt == "오늘은 가임기 시작일이에요." || _menstrualCycle.getFertileWindowStartDt == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getFertileWindowStartDt == "오늘은 가임기 시작일이에요.") ? "" : _menstrualCycle.getFertileWindowStartDt;
        break;
      case "가임기 종료일":
        alarmCategory = "fertileWindowsEndDtAlarm";
        contentText = (_menstrualCycle.getFertileWindowsEndDt == "" || _menstrualCycle.getMenstruation3DaysAgo != "오늘은 가임기 마지막날이에요.") ? "오늘은 가임기 마지막날이에요." : _menstrualCycle.getFertileWindowsEndDt;
        sendCategory = "fertileWindowsEndDt";
        switchValue = (_menstrualCycle.getFertileWindowsEndDtAlarm == "" || _menstrualCycle.getFertileWindowsEndDtAlarm == "N") ? false : true;
        selectedValue = (_menstrualCycle.getFertileWindowsEndDt == "오늘은 가임기 마지막날이에요." || _menstrualCycle.getFertileWindowsEndDt == "") ? "기본 문구" : "직접 입력";
        _editingController.text = (_menstrualCycle.getFertileWindowsEndDt == "오늘은 가임기 마지막날이에요.") ? "" : _menstrualCycle.getFertileWindowsEndDt;
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
                          bool result = await _menstrualCycle.setMenstrualCycleMessage(alarmCategory, (switchValue == true) ? "Y" : "N", sendCategory, contentText, "myData");

                          if (result == true) {
                            switch (category) {
                              case "생리 예정 3일전":
                                _menstrualCycle.setMenstruation3DaysAgoAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruation3DaysAgo = "오늘은 생리 예정 3일전이에요.";
                                break;
                              case "생리 예정일":
                                _menstrualCycle.setMenstruationDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruationDt = "오늘은 생일 예정일이에요.";
                                break;
                              case "배란 예정일":
                                _menstrualCycle.setOvulationDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setOvulationDt = "오늘은 배란 예정일이에요.";
                                break;
                              case "가임기 시작일":
                                _menstrualCycle.setFertileWindowStartDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowStartDt = "오늘부터 가임기 시작이에요.";
                                break;
                              case "가임기 종료일":
                                _menstrualCycle.setFertileWindowsEndDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowsEndDt = "오늘은 가임기 마지막날이에요.";
                                break;
                            }
                            await _saveSuccessAlert(context);
                            setState(() {

                            });
                          } else {
                            _failureAlert(context);
                          }
                        } else {
                          // 직접 입력일때는 _editingController 의 text 를 가져오면 댐
                          bool result = await _menstrualCycle.setMenstrualCycleMessage(alarmCategory, (switchValue == true) ? "Y" : "N", sendCategory, _editingController.text, "myData");

                          if (result == true) {
                            switch (category) {
                              case "생리 예정 3일전":
                                _menstrualCycle.setMenstruation3DaysAgoAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruation3DaysAgo = _editingController.text;
                                break;
                              case "생리 예정일":
                                _menstrualCycle.setMenstruationDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setMenstruationDt = _editingController.text;
                                break;
                              case "배란 예정일":
                                _menstrualCycle.setOvulationDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setOvulationDt = _editingController.text;
                                break;
                              case "가임기 시작일":
                                _menstrualCycle.setFertileWindowStartDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowStartDt = _editingController.text;
                                break;
                              case "가임기 종료일":
                                _menstrualCycle.setFertileWindowsEndDtAlarm = (switchValue == true) ? "Y" : "N";
                                _menstrualCycle.setFertileWindowsEndDt = _editingController.text;
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
          FontAwesomeIcons.checkCircle,
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
