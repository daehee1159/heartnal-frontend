import 'package:couple_signal/src/models/anniversary/anniversary.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

String datetime = "";
DateTime pickedDatetime = DateTime.now();
var _isChecked = false;
List<Anniversary> anniversaryList = [];

class CreateAnniversary extends StatefulWidget {
  const CreateAnniversary({Key? key}) : super(key: key);

  @override
  _CreateAnniversaryState createState() => _CreateAnniversaryState();
}

class _CreateAnniversaryState extends State<CreateAnniversary> {
  TextEditingController anniversaryTitleController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    // anniversaryTitleController = new TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    anniversaryTitleController.dispose();
    // anniversaryTitleController.clear();
  }

  DateTime currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    Anniversary _anniversary = Provider.of<Anniversary>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "기념일 추가하기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _cancelAlertDialog(context);
            setState(() {
              _isChecked = false;
              datetime = "";
              pickedDatetime = DateTime.now();
            });
          },
        ),
        actions: [
          TextButton(
            child: Text(
              "저장",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: () async {
              // 0보다 크면 현재 날짜보다 지난 날짜(= 이전 날짜)
              int daysBetween = _daysBetween(pickedDatetime, currentDate);

              if (datetime == "") {
                _datetimeAlertDialog(context);
              } else if (!_isChecked && daysBetween >= 0) {
                // 반복이 아닌데 과거의 날짜를 선택 했을 때 방지
                _dateTimeErrorAlertDialog(context);
              }
              else if (anniversaryTitleController.text == "" || anniversaryTitleController.text.isEmpty) {
                _titleAlertDialog(context);
              } else {
                GlobalAlert().onLoading(context);
                await _anniversary.setAnniversary(anniversaryTitleController.text, pickedDatetime, _isChecked);
                setState(() {
                  _isChecked = false;
                  anniversaryTitleController.text = '';
                  currentDate = DateTime.now();
                  anniversaryList = _anniversary.anniversaryList;
                  _isChecked = false;
                });
                await Future.delayed(Duration(seconds: 2));
                await _completeAlertDialog(context);
              }
            },
          )
        ],
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          // reverse: true,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.19,
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "날짜 선택하기",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      datetime == "" ? "날짜 미선택" : datetime,
                                      style: datetime == "" ? Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey) : Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: const SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextButton.icon(
                                      onPressed: () async {
                                        DateTime currentDate = DateTime.now();
                                        bool isCanceled = true;

                                        ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

                                        Future<void> _selectDate(BuildContext context) async {
                                          final DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: currentDate,
                                            locale: Locale('ko'),
                                            helpText: "",
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2050),
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
                                            pickedDatetime = pickedDate;
                                            datetime = pickedDate.toString().substring(0, 10);
                                            // await _myProfileInfo.updateCoupleRegDt(pickedDate);
                                          }
                                        }
                                        await _selectDate(context);
                                        if (isCanceled) {
                                          setState(() {

                                          });
                                        }
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.calendarAlt,
                                        color: Colors.white,
                                        size: 23,
                                      ),
                                      label: Padding(
                                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.005, 0, 0),
                                        child: Text(
                                          "날짜 선택",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                        ),
                                      ),
                                      style: TextButton.styleFrom(
                                          backgroundColor: const Color(0xffFE9BE6)
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.16,
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                              child: Text(
                                '기념일 제목 설정하기',
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              child: Card(
                                color: Colors.white,
                                elevation: 0.0,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: Colors.grey)
                                ),
                                margin: const EdgeInsets.all(0.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextField(
                                    textInputAction: TextInputAction.done,
                                    controller: anniversaryTitleController,
                                    style: Theme.of(context).textTheme.bodyText2,
                                    decoration: InputDecoration.collapsed(
                                      hintText: '제목을 입력해주세요!',
                                      hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                    ),
                                    maxLines: 5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    ),
                  ),
                  Container(
                    child: Card(
                      elevation: 4.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        _isChecked = !_isChecked;
                                      });
                                    },
                                  ),
                                  GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                                        child: Text(
                                          '반복 설정 여부',
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          /// toggle isChecked
                                          _isChecked = !_isChecked;
                                        });
                                      }
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  _cancelAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "기념일 등록 취소",
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
        '기념일 등록을 취소하시겠습니까?',
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

  _titleAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "제목 미입력",
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
        '기념일 제목을 입력해주세요!',
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

  _datetimeAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "날짜 미선택",
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
        '원하는 날짜를 선택해주세요!',
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

  _completeAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "완료",
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
        '기념일 등록이 완료되었어요!',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
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

  _dateTimeErrorAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "날짜 선택 오류",
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
        '반복 체크를 하지 않은 경우\n현재보다 과거의 날짜를\n선택할 수 없어요!',
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

  /// D-day
  /// from = 비교날짜, to = 현재날짜
  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}
