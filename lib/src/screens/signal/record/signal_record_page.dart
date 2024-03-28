import 'package:couple_signal/src/screens/signal/record/eat_signal_record_detail.dart';
import 'package:couple_signal/src/screens/signal/record/message_of_the_day_record.dart';
import 'package:couple_signal/src/screens/signal/record/play_signal_record_detail.dart';
import 'package:couple_signal/src/screens/signal/record/today_signal_record.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class SignalRecordPage extends StatelessWidget {
  const SignalRecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "시그널 이력보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
              color: const Color(0xffFFF7F3),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "여러가지 시그널 이력을",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "확인해보세요!",
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      FontAwesomeIcons.folderOpen,
                      size: 60,
                      color: Color(0xffFE9BE6),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Card(
                              // color: const Color(0xffFEEAEA),
                              // color: const Color(0xffEDE4FE),
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: Container(
                                // color: const Color(0xffFFF1F5).withOpacity(0.5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                      'images/json/icon/icon_eat_signal.json',
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      height: MediaQuery.of(context).size.height * 0.08
                                    ),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                      child: Text(
                                        "오늘 뭐먹지?",
                                        style: Theme.of(context).textTheme.bodyText1,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => EatSignalRecordDetail()));
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Card(
                              // color: const Color(0xffE4EDFF),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Container(
                                  // color: const Color(0xffFFF1F5).withOpacity(0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'images/json/icon/icon_play_signal.json',
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height * 0.10
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                          "오늘 뭐하지?",
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlaySignalRecordDetail()));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Card(
                              // color: const Color(0xffE4EDFF),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Container(
                                  // color: const Color(0xffFFF1F5).withOpacity(0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                          'images/json/icon/icon_message_of_the_day.json',
                                          width: MediaQuery.of(context).size.width * 0.25,
                                          height: MediaQuery.of(context).size.height * 0.10
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                          "오늘의 한마디",
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayRecord()));
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Card(
                              // color: const Color(0xffE4EDFF),
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Container(
                                  // color: const Color(0xffFFF1F5).withOpacity(0.5),
                                  padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Lottie.asset(
                                        'images/json/icon/icon_today_signal.json',
                                        width: MediaQuery.of(context).size.width * 0.20,
                                        height: MediaQuery.of(context).size.height * 0.08
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
                                        child: Text(
                                          "오늘의 시그널",
                                          style: Theme.of(context).textTheme.bodyText1,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalRecord()));
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            width: MediaQuery.of(context).size.width * 0.45,
                            height: MediaQuery.of(context).size.height * 0.23,
                            child: Card(
                                color: Colors.grey.shade50,
                                elevation: 4.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Container(
                                  // color: const Color(0xffFFF1F5).withOpacity(0.5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                        child: Icon(
                                          FontAwesomeIcons.keyboard,
                                          size: 35,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                          "준비중입니다!",
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.grey),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                            ),
                          ),
                          onTap: () {

                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          child: Container(),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
