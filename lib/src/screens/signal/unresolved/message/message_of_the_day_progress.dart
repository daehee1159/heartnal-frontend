import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

int _memberSeq = 0;
late MessageOfTheDayDto senderData;
late MessageOfTheDayDto recipientData;
bool isSenderSent = false;
bool isRecipientSent = false;

class MessageOfTheDayProgress extends StatefulWidget {
  const MessageOfTheDayProgress({Key? key}) : super(key: key);

  @override
  State<MessageOfTheDayProgress> createState() => _MessageOfTheDayProgressState();
}

class _MessageOfTheDayProgressState extends State<MessageOfTheDayProgress> {
  @override
  void initState() {
    super.initState();
    _getMemberSeq();
  }

  @override
  Widget build(BuildContext context) {
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);
    List<MessageOfTheDayDto> messageOfTheDayList = [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 한마디 현황보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _messageOfTheDay.getTodayMessageOfTheDay(),
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
          } else if (snapshot.connectionState == ConnectionState.done && (snapshot.data == null || snapshot.data.isEmpty)) {
            /// 기록이 없는 경우 카테고리 클릭해서 넘어가면 없다는 것을 알려줘야함
            MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
            return GestureDetector(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xffFFF1F5).withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(
                            'images/json/icon/icon_message_of_the_day.json',
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.15
                          ),
                        ),
                        Center(
                          child: Text(
                            "우리 둘만의 오늘의 한마디",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.05, 0),
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                          // color: const Color(0xffFFF1F5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                flex: 13,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        )
                                      )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
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
                                          _myProfileInfo.nickName.toString(),
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                        ),
                                        Spacer(),
                                        Text(
                                          "",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                        ),
                                        SizedBox(height: 10.0,)
                                      ],
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 37,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "아직 오늘의 한마디를 작성하지 않았어요!",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                          // color: const Color(0xffFFF1F5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 37,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "아직 상대방이 오늘의 한마디를 작성하지 않았어요!",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 13,
                                child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        left: BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        )
                                      )
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Spacer(),
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
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                        ),
                                        Spacer(),
                                        Text(
                                          "",
                                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                        ),
                                        SizedBox(height: 10.0,)
                                      ],
                                    )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: const Color(0xffFE9BE6),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
              onTap: () {},
            );
          } else {
            messageOfTheDayList = snapshot.data;

            /// 초기화
            recipientData = MessageOfTheDayDto(
                messageOfTheDaySeq: 0,
                coupleCode: messageOfTheDayList[0].coupleCode,
                senderMemberSeq: 0,
                recipientMemberSeq: 0,
                message: "아직 상대방이 오늘의 한마디를 작성하지 않았어요!",
                regDt: ""
            );
            senderData = MessageOfTheDayDto(
                messageOfTheDaySeq: 0,
                coupleCode: messageOfTheDayList[0].coupleCode,
                senderMemberSeq: 0,
                recipientMemberSeq: 0,
                message: "아직 오늘의 한마디를 작성하지 않았어요!",
                regDt: ""
            );

            for (var i = 0; i < messageOfTheDayList.length; i++) {
              if (messageOfTheDayList[i].senderMemberSeq == _memberSeq) {
                senderData = messageOfTheDayList[i];
                isSenderSent = true;
                break;
              }
            }

            for (var i = 0; i < messageOfTheDayList.length; i++) {
              if (messageOfTheDayList[i].senderMemberSeq != _memberSeq) {
                recipientData = messageOfTheDayList[i];
                isSenderSent = true;
                break;
              } else {

              }
            }

            MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
            String today = DateTime.now().year.toString() + "년 " + DateTime.now().month.toString() + "월 " + DateTime.now().day.toString() + "일";
            return GestureDetector(
              child: Column(
                children: [
                  Container(
                    color: const Color(0xffFFF1F5).withOpacity(0.5),
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    height: MediaQuery.of(context).size.height * 0.25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Lottie.asset(
                            'images/json/icon/icon_message_of_the_day.json',
                            width: MediaQuery.of(context).size.width * 0.30,
                            height: MediaQuery.of(context).size.height * 0.15
                          ),
                        ),
                        Center(
                          child: Text(
                            "우리 둘만의 오늘의 한마디",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    margin: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.05, 0),
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: Colors.blue,
                                ),
                              ),
                              Expanded(
                                flex: 13,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      right: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      )
                                    )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
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
                                        _myProfileInfo.nickName.toString(),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        (senderData.regDt.toString() == "") ? "" : senderData.regDt.toString().substring(0, 10),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                      ),
                                      SizedBox(height: 10.0,)
                                    ],
                                  )
                                ),
                              ),
                              Expanded(
                                flex: 37,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          senderData.message.toString(),
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.23,
                    margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.05, 0, 0, 0),
                    child: Card(
                        elevation: 4.0,
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 37,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          recipientData.message.toString(),
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 13,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      )
                                    )
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
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
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 13.0),
                                      ),
                                      Spacer(),
                                      Text(
                                        (recipientData.regDt.toString() == "") ? "" : recipientData.regDt.toString().substring(0, 10),
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 11.0),
                                      ),
                                      SizedBox(height: 10.0,)
                                    ],
                                  )
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  color: const Color(0xffFE9BE6),
                                ),
                              ),
                            ],
                          ),
                        )
                    ),
                  ),
                ],
              ),
              onTap: () {},
            );
          }
        },
      ),
    );
  }
  _getMemberSeq() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    _memberSeq = memberSeq;
  }
}
