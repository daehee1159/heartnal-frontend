import 'package:couple_signal/src/models/signal/today/today_signal_record_detail_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/info/my_profile_info.dart';
import '../../../models/signal/today/today_signal.dart';

class TodaySignalRecordDetail extends StatefulWidget {
  final int todaySignalSeq;
  final bool isSender;
  final String finalScore;
  final String regDt;
  const TodaySignalRecordDetail({Key? key, required this.todaySignalSeq, required this.isSender, required this.finalScore, required this.regDt}) : super(key: key);

  @override
  State<TodaySignalRecordDetail> createState() => _TodaySignalRecordDetailState();
}

class _TodaySignalRecordDetailState extends State<TodaySignalRecordDetail> {
  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 시그널 자세히 보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        // backgroundColor: const Color(0xffFFFADF),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _todaySignal.getTodaySignalRecordDetail(this.widget.todaySignalSeq),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator()
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          } else {
            List<TodaySignalRecordDetailDto> detail = snapshot.data;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(3, 0, 3, 0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Colors.black, width: 1
                    ),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xffFFF7F3),
                        child: Text(
                          this.widget.regDt,
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      (this.widget.isSender == true) ?
                      Container(
                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03),
                        // color: const Color(0xffFFFADF),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                  ) :
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    _myProfileInfo.getNickName,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.12,
                                    height: MediaQuery.of(context).size.height * 0.08,
                                    child: OverflowBox(
                                      minHeight: MediaQuery.of(context).size.height * 0.08,
                                      maxHeight: MediaQuery.of(context).size.height * 0.08,
                                      minWidth: MediaQuery.of(context).size.width * 0.12,
                                      maxWidth: MediaQuery.of(context).size.width * 0.12,
                                      child: Lottie.asset(
                                        'images/json/icon/icon_heart.json',
                                        width: MediaQuery.of(context).size.width * 0.12,
                                        height: MediaQuery.of(context).size.height * 0.08
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.002,),
                                  Text(
                                    this.widget.finalScore + '점',
                                    style: Theme.of(context).textTheme.bodyText1,
                                  )
                                ],
                              )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                  ) :
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    _myProfileInfo.coupleNickName.toString(),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ) :
                      Container(
                        padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.03, 0, MediaQuery.of(context).size.height * 0.03),
                        // color: const Color(0xffFFF7F3),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                  ) :
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    _myProfileInfo.coupleNickName.toString(),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.12,
                                      height: MediaQuery.of(context).size.height * 0.08,
                                      child: OverflowBox(
                                        minHeight: MediaQuery.of(context).size.height * 0.08,
                                        maxHeight: MediaQuery.of(context).size.height * 0.08,
                                        minWidth: MediaQuery.of(context).size.width * 0.12,
                                        maxWidth: MediaQuery.of(context).size.width * 0.12,
                                        child: Lottie.asset(
                                          'images/json/icon/icon_heart.json',
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          height: MediaQuery.of(context).size.height * 0.08
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.002,),
                                    Text(
                                      this.widget.finalScore + '점',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    )
                                  ],
                                )
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                  ) :
                                  CircleAvatar(
                                    radius: MediaQuery.of(context).size.width * 0.07,
                                    backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                                  ),
                                  SizedBox(height: 10.0,),
                                  Text(
                                    _myProfileInfo.getNickName,
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: detail.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          String indexToString = (index + 1).toString();
                          List<String> questionList = [];
                          if (detail[index].question.toString().contains('vs')) {
                            questionList = detail[index].question.toString().split('vs');
                          }

                          return Container(
                            // color: const Color(0xffFFF7F3),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: const Divider(color: Colors.black, height: 1.5,),
                                ),
                                Container(
                                  padding: EdgeInsets.all(10.0),
                                  color: const Color(0xffFFFAF7),
                                  height: MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      (detail[index].question.toString().contains('vs')) ?
                                      Center(
                                        child: Text(
                                          '$indexToString. ' + questionList[0] + '\nVS\n' + questionList[1],
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
                                          textAlign: TextAlign.center,
                                        ),
                                      ) :
                                      Center(
                                        child: Text(
                                          '$indexToString. ' + detail[index].question.toString(),
                                          style: Theme.of(context).textTheme.bodyText2,
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03, horizontal: 10),
                                  // color: const Color(0xffF2FFF2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Text(
                                                detail[index].senderAnswer.toString(),
                                                style: Theme.of(context).textTheme.bodyText2,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Icon(
                                            (detail[index].senderAnswer.toString() == detail[index].recipientAnswer.toString()) ? FontAwesomeIcons.circleCheck : FontAwesomeIcons.circleXmark,
                                            color: (detail[index].senderAnswer.toString() == detail[index].recipientAnswer.toString()) ? Colors.blue : Colors.red,
                                            size: MediaQuery.of(context).size.height * 0.05,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Text(
                                              detail[index].recipientAnswer.toString(),
                                              style: Theme.of(context).textTheme.bodyText2,
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
