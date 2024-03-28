import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/couple_unresolved_signal_dto.dart';
import 'package:couple_signal/src/screens/signal/message/message_of_the_day_input.dart';
import 'package:couple_signal/src/screens/signal/unresolved/signal_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../models/signal/message/message_of_the_day.dart';
import '../../../models/signal/message/message_of_the_day_dto.dart';

bool hasUnResolved = false;
int eatSignalSeq = 0;
int playSignalSeq = 0;
int messageOfTheDaySeq = 0;
int todaySignalSeq = 0;
List<MessageOfTheDayDto>? messageOfTheDayDtoList;

/// 오늘의 메시지(한마디)
class MessageOfTheDayPage extends StatelessWidget {
  const MessageOfTheDayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 한마디 보내기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Container(
        // color: const Color(0xffF2F2F2),
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.23,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                  elevation: 4.0,
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10)
                    // ),
                    color: const Color(0xffFFF1F5).withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              Text(
                                "하루에 한 번!",
                                style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                              ),
                              SizedBox(height: 3,),
                              Text(
                                "사랑하는 연인에게",
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              SizedBox(height: 3,),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '오늘의 한마디',
                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                    ),
                                    TextSpan(
                                      text: '를 보내주세요!',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ]
                                ),
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  )
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.15,
              child: Card(
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
                      Image.asset(
                        'images/heartnal_bi.png',
                        height: MediaQuery.of(context).size.height * 0.04,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                )
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Column(
              children: [
                Container(
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
                                                  '지금 작성하기',
                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                              child: Text(
                                                '이미지를 클릭해주세요!',
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
                                                  padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.2, 55),
                                                  onPressed: () async {
                                                    bool result = await _signalCheckProgress("messageOfTheDay");
                                                    if (result) {
                                                      signalProgressAlert(context, "messageOfTheDay");
                                                    } else {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayInput()));
                                                    }
                                                  },
                                                  icon: Icon(
                                                    FontAwesomeIcons.keyboard,
                                                    color: const Color(0xffFE9BE6),
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
                        onTap: () async {
                          bool result = await _signalCheckProgress("messageOfTheDay");
                          if (result) {
                            signalProgressAlert(context, "messageOfTheDay");
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayInput()));
                          }
                        },
                      )
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.20,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                // color: const Color(0xff126BC4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Text(
                                      "하루에 한 번만 보낼 수 있어요!",
                                      style: Theme.of(context).textTheme.bodyText1
                                    ),
                                  ],
                                )
                            ),
                            onTap: () {

                            },
                          ),
                        ],
                      )
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  _signalCheckProgress(String category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);
    String coupleCode = pref.getString(Glob.coupleCode).toString();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());

    var url = Uri.parse(Glob.memberUrl + '/check/unresolved/$coupleCode/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    CoupleUnResolvedSignalDto coupleUnResolvedSignalDto = CoupleUnResolvedSignalDto.fromJson(jsonDecode(response.body));
    if (coupleUnResolvedSignalDto.hasUnResolved == false) {
      hasUnResolved = false;
      return false;
    } else {
      hasUnResolved = true;

      if (category == 'messageOfTheDay') {
        eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
        playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
        messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
        todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;

        if (messageOfTheDaySeq != 0) {
          return true;
        } else {
          return false;
        }
      }

      /// 여기는 오늘의 한마디 시그널이기 때문에 나머지 시그널들까지 체크할 필요가 없음음

     // if (category == "eatSignal") {
      //   eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
      //   playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
      //   messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
      //   todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;
      //
      //   if (eatSignalSeq != 0) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // } else if (category == "playSignal") {
      //   eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
      //   playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
      //   messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
      //   todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;
      //
      //   if (playSignalSeq != 0) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // } else if (category == 'messageOfTheDay') {
      //   eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
      //   playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
      //   messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
      //   todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;
      //
      //   if (messageOfTheDaySeq != 0) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // } else {
      //   eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
      //   playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
      //   messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
      //   todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;
      //
      //   if (todaySignalSeq != 0) {
      //     return true;
      //   } else {
      //     return false;
      //   }
      // }
    }
  }
  signalProgressAlert(BuildContext context, String category) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "진행 불가",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (category == "messageOfTheDay") ?
          Text(
            '오늘 전송 횟수를 초과했어요.\n시그널 진행상황을 확인해주세요!',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ) :
          Text(
            '이미 진행중인 시그널이 있어요.\n시그널 진행상황을 확인해주세요!',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);
            messageOfTheDayDtoList = await _messageOfTheDay.getTodayMessageOfTheDay();
            if (messageOfTheDayDtoList == null || messageOfTheDayDtoList?.length == 0) {
              // 리스트가 null 이면 진행중인 오늘의 한마디가 없으므로 0
              messageOfTheDaySeq = 0;
            } else {
              // 리스트가 null 이 아니면 진행중인 오늘의 한마디가 있으므로 1
              messageOfTheDaySeq = 1;
            }
            
            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgress(
              hasUnResolved: hasUnResolved,
              eatSignalSeq: eatSignalSeq,
              playSignalSeq: playSignalSeq,
              messageOfTheDaySeq: messageOfTheDaySeq,
              todaySignalSeq: todaySignalSeq,
            )));
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
}
