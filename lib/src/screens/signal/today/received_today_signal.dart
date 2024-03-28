import 'package:couple_signal/src/screens/signal/today/result_today_signal.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_question1.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../models/signal/today/today_signal_questions_dto.dart';

class ReceivedTodaySignal extends StatelessWidget {
  final bool termination;
  final String position;
  final List<TodaySignalQuestionsDto> questionList;
  final int todaySignalSeq;

  const ReceivedTodaySignal({Key? key, required this.termination, required this.position, required this.questionList, required this.todaySignalSeq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          'images/heartnal_bi.png',
          height: MediaQuery.of(context).size.height * 0.04,
          fit: BoxFit.contain,
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: const Color(0xffFFF1F5).withOpacity(0.5),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              // height: MediaQuery.of(context).size.height * 0.25,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'images/json/icon/icon_today_signal.json',
                      width: MediaQuery.of(context).size.width * 0.55,
                      height: MediaQuery.of(context).size.height * 0.45,
                    )
                  ),
                  SizedBox(height: 15.0,),
                  Center(
                    child: Text(
                      "오늘의 시그널이 도착했어요!",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
            (this.termination == true) ?
            /// 시그널 결과 페이지
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextButton(
                  child: Text(
                    '결과보기',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffFE9BE6),
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ResultTodaySignal(todaySignalSeq: this.todaySignalSeq,)));
                  },
                ),
              ),
            )
            :
            /// 시그널 문제 페이지
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextButton(
                  child: Text(
                    '답장하기',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffFE9BE6),
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: this.position, questionList: this.questionList, todaySignalSeq: this.todaySignalSeq)));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
