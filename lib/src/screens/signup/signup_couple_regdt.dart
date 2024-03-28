import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:couple_signal/src/screens/signup/signup_code_input.dart';
import 'package:couple_signal/src/screens/signup/signup_code_main.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String datetime = "";

class SignupCoupleRegDt extends StatefulWidget {
  const SignupCoupleRegDt({Key? key}) : super(key: key);

  @override
  _SignupCoupleRegDtState createState() => _SignupCoupleRegDtState();
}

class _SignupCoupleRegDtState extends State<SignupCoupleRegDt> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            width: double.infinity,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Image.asset(
                      'images/heartnal_bi.png',
                      height: MediaQuery.of(context).size.height * 0.07,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    Text(
                      '당신의 연인과 \n처음 만난 날을 알려주세요.',
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.08,),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              datetime == "" ? "날짜 미선택" : datetime,
                              style: datetime == "" ? Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey, fontSize: 18.0) : Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0),
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
                                    datetime = pickedDate.toString().substring(0, 10);
                                    /// coupleRegDt 저장
                                    bool result = await _setCoupleRegDt(datetime);
                                    if (result) {
                                    } else {
                                      GlobalAlert globalAlert = new GlobalAlert();
                                      /// 실패 alert
                                      globalAlert.globErrorAlert(context);
                                      datetime = "";
                                    }
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    TextButton(
                      child: Text(
                        '다음',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(15),
                        backgroundColor: const Color(0xffFE9BE6),
                      ),
                      onPressed: () {
                        if (datetime == "null" || datetime == "") {
                          _failureAlertDialog(context);
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupCodeMain()));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => SignupCode()));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Future<bool> _setCoupleRegDt(String coupleRegDt) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool result = await pref.setString(Glob.coupleRegDt, coupleRegDt);
    return result;
  }

  _failureAlertDialog(BuildContext context) async {
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
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        "날짜를 선택해주세요!",
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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
