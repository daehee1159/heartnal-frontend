import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:couple_signal/src/screens/signal/started_signal.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late MessageOfTheDayDto senderData;
int _memberSeq = 0;

/// 오늘의 한마디 직접 입력 페이지
class MessageOfTheDayInput extends StatefulWidget {
  const MessageOfTheDayInput({Key? key}) : super(key: key);

  @override
  State<MessageOfTheDayInput> createState() => _MessageOfTheDayInputState();
}

class _MessageOfTheDayInputState extends State<MessageOfTheDayInput> {
  TextEditingController _textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMemberSeq();
    _textController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    List<MessageOfTheDayDto> messageOfTheDayList = [];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 한마디 작성하기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            _textController.text = "";
            _cancelAlertDialog(context);
          },
        ),
        actions: [
          TextButton(
            child: Text(
              "작성",
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
            ),
            onPressed: () async {
              if (_textController.text.toString() == "" || _textController.text.toString() == " " || _textController.text.isEmpty) {
                return _emptyAlertDialog(context);
              } else {
                _confirmAlert(context, _textController.text.toString());
              }
            },
          )
        ],
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
            return GestureDetector(
              child: SingleChildScrollView(
                child: Container(
                  /// color 빼면 FocusScope.of(context).unfocus(); 이게 안먹는듯?
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: Column(
                    children: [
                      Container(
                        // color: const Color(0xffFFF1F5).withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Card(
                                color: const Color(0xffFFF1F5),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Text(
                                      "아직 상대방이 오늘의 한마디를 작성하지 않았어요!",
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * -0.060,
                              child: Container(
                                child: (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width * 0.08,
                                  backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                ) :
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width * 0.08,
                                  backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xffFE9BE6), width: 4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                      Stack(
                        alignment: AlignmentDirectional.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Card(
                              color: Colors.blue.shade50,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(32, 56, 32, 32),
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: MediaQuery.of(context).size.height * 0.25,
                                child: TextField(
                                  controller: _textController,
                                  maxLines: 4,
                                  maxLength: 100,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration.collapsed(
                                    hintText: '오늘의 한마디를 적어주세요!',
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * -0.075,
                            child: Container(
                              child: (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                              ) :
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue.shade200, width: 4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
              },
            );
          } else {
            messageOfTheDayList = snapshot.data;
            for (var i = 0; i < messageOfTheDayList.length; i++) {
              /// 상대방이 보낸 오늘의 한마디만 찾으면 되므로 이렇게 함
              if (messageOfTheDayList[i].senderMemberSeq != _memberSeq) {
                senderData = messageOfTheDayList[i];
              }
            }
            return GestureDetector(
              child: SingleChildScrollView(
                child: Container(
                  /// color 빼면 FocusScope.of(context).unfocus(); 이게 안먹는듯?
                  color: Colors.white,
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: Column(
                    children: [
                      Container(
                        // color: const Color(0xffFFF1F5).withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: Stack(
                          alignment: AlignmentDirectional.topCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Center(
                              child: Card(
                                color: const Color(0xffFFF1F5),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(32, 32, 32, 32),
                                  width: MediaQuery.of(context).size.width * 0.75,
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Center(
                                    child: Text(
                                      senderData.message.toString(),
                                      style: Theme.of(context).textTheme.bodyText2,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * -0.060,
                              child: Container(
                                child: (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width * 0.08,
                                  backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                ) :
                                CircleAvatar(
                                  radius: MediaQuery.of(context).size.width * 0.08,
                                  backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                ),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xffFE9BE6).withOpacity(0.5), width: 4),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.13,),
                      Stack(
                        alignment: AlignmentDirectional.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Center(
                            child: Card(
                              color: Colors.blue.shade50,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(32, 56, 32, 32),
                                width: MediaQuery.of(context).size.width * 0.75,
                                height: MediaQuery.of(context).size.height * 0.25,
                                child: TextField(
                                  controller: _textController,
                                  maxLines: 4,
                                  maxLength: 100,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  decoration: InputDecoration.collapsed(
                                    hintText: '오늘의 한마디를 적어주세요!',
                                    hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: MediaQuery.of(context).size.height * -0.070,
                            child: Container(
                              child: (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                              ) :
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width * 0.08,
                                backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                              ),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.blue.shade200, width: 4),
                                shape: BoxShape.circle,
                              ),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
              },
            );
          }
        }
      ),
    );
  }

  _cancelAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "작성 취소",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {

        },
      ),
      content: Text(
        '작성을 취소하시겠습니까?',
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

  _emptyAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "메시지 미입력",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {

        },
      ),
      content: Text(
        '오늘의 한마디를 입력해주세요!',
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

  _confirmAlert(BuildContext context, String message) async {
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "오늘의 한마디",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: const Color(0xffFE9BE6),
        ),
        onPressed: () {},
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '전송',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xffFE9BE6)),
          ),
          onPressed: () async {
            GlobalAlert().onLoading(context);
            bool result = await _messageOfTheDay.setMessageOfTheDay(_textController.text.toString());
            if (result == true) {
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop();
              _textController.clear();
              _saveSuccessAlert(context);
            } else {
              await Future.delayed(Duration(seconds: 2));
              GlobalAlert().globErrorAlert(context);
            }
          },
        ),
        TextButton(
          child: Text(
            '취소',
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

  _saveSuccessAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "전송 완료",
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
        '전송에 성공했어요!',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => StartSignal()));
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

  _getMemberSeq() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    _memberSeq = memberSeq;
  }
}
